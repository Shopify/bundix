# typed: strict
# frozen_string_literal: true
require('bundix')

module Bundix
  # Converter converts a Gemfile.lock (Bundler::LockfileParser) into a gemset.nix data structure
  # (T_GEMSET), using a previous version of that gemset.nix (or an empty hash) as a reference.
  class Converter
    extend(T::Sig)

    sig { params(lockfile: ::Bundler::LockfileParser, previous_gemset: T_GEMSET).void }
    def initialize(lockfile:, previous_gemset:)
      @lockfile        = T.let(lockfile, ::Bundler::LockfileParser)
      @previous_gemset = T.let(previous_gemset, T_GEMSET)
    end

    sig { params(fetcher: ::Bundix::Fetcher).returns(T_GEMSET) }
    def convert(fetcher: ::Bundix::Fetcher.new)
      dep_cache = build_depcache(@lockfile)

      gemset = T.let({}, T_GEMSET)
      mutex = Mutex.new
      Parallel.each_spec(@lockfile.specs) do |spec|
        name = T.must(spec.name)
        entry = fetch_or_build_entry(spec, @previous_gemset, fetcher, dep_cache)
        mutex.synchronize { gemset[name] = entry }
      end
      gemset
    end

    private

    sig do
      params(
        spec: ::Bundler::LazySpecification, # Given a gem specification
        previous_gemset: T_GEMSET, # try to find a suitable entry in the previous gemset
        fetcher: ::Bundix::Fetcher, # or build one by fetching the remote if necessary
        dep_cache: T::Hash[String, ::Bundler::Dependency] # and assign the correct dependencies.
      ).returns(T_GEMSET_ENTRY) # Return this in the format that we'll serialize into gemset.nix.
      # Importantly, note that this is run concurrently, so any output generated should be careful
      # to not look bad in that context.
    end
    def fetch_or_build_entry(spec, previous_gemset, fetcher, dep_cache)
      entry = find_entry_in_previous_gemset(spec, previous_gemset)

      unless entry
        dep = dep_cache.fetch(T.must(spec.name))
        entry = generate_uncached_entry(spec, fetcher, dep)
      end

      entry['dependencies'] = spec.dependencies.map(&:name) - ['bundler']
      entry
    end

    sig do
      params(
        spec: ::Bundler::LazySpecification, # Given a gem specification,
        fetcher: ::Bundix::Fetcher, # fetch the gem to get the sha256 sum
        dep: ::Bundler::Dependency
      ).returns(T_GEMSET_ENTRY) # return a hash in the format that we'll serialize into gemset.nix.
    end
    def generate_uncached_entry(spec, fetcher, dep)
      # TODO: skip or blow up on error?
      version, source = ::Bundix::Source.convert(spec, fetcher)
      {
        'dependencies' => [], # to be filled in later
        'platforms' => ::Bundix::PlatformResolver.resolve(dep.platforms),
        'groups' => dep.groups.map(&:to_s),
        'version' => version,
        'source' => source,
      }
    end

    sig do
      params(
        spec: ::Bundler::LazySpecification, # Given a gem specification
        previous_gemset: T_GEMSET # and the deserialized previous version of gemset.nix, if any,
      ).returns(
        # return an entry from that gemset having the same name, type, and version (or
        # "revision", if it's a git source), or just nil if no matches are found.
        T.nilable(T_GEMSET_ENTRY)
      )
    end
    def find_entry_in_previous_gemset(spec, previous_gemset)
      _name, cached = previous_gemset.find do |k, v|
        next unless k == spec.name
        next unless (cached_source = v['source'])

        case spec_source = spec.source
        when ::Bundler::Source::Git
          # Our spec has a git source. Do the type (git) and revision/sha match?
          next unless cached_source['type'] == 'git'
          next unless (cached_rev = cached_source['rev'])
          next unless (spec_rev = spec_source.options['revision'])
          spec_rev == cached_rev
        when ::Bundler::Source::Rubygems
          # Our spec has a gem source. Do the type (gem) and version match?
          next unless cached_source['type'] == 'gem'

          has_platform = spec.platform && spec.platform != ::Gem::Platform::RUBY
          if has_platform
            # This is not really idea. For example, spec.version on my machine reports
            # universal-darwin-14 for sorbet-static, but the gem we fetch is universal-darwin-19.
            # Ideally we could detect if the gemset.nix includes an actually-incompatible platform,
            # but it's not clear from this vantage point what the correct way to make this call is.
            # For now, we'll just be lazy I guess?
            v['version'].start_with?("#{spec.version}-")
          else
            v['version'] == spec.version.to_s
          end
        end
      end

      cached
    end

    sig { params(lock: ::Bundler::LockfileParser).returns(T::Hash[String, ::Bundler::Dependency]) }
    def build_depcache(lock)
      dep_cache = T.let({}, T::Hash[String, ::Bundler::Dependency])

      lock.dependencies.each do |_gem_name, dep|
        dep_cache[dep.name] = dep
      end

      lock.specs.each do |spec|
        name = T.must(spec.name)
        dep_cache[name] ||= ::Bundler::Dependency.new(name, nil, {})
      end

      loop do
        changed = T.let(false, T::Boolean)
        lock.specs.each do |spec|
          as_dep = dep_cache.fetch(T.must(spec.name))

          spec.dependencies.each do |dep|
            cached = dep_cache.fetch(dep.name) do |name|
              if name != 'bundler'
                raise(::KeyError, "Gem dependency '#{name}' not specified in Gemfile.lock")
              end
              dep_cache[name] = ::Bundler::Dependency.new(name, lock.bundler_version, {})
            end

            missing_groups = (as_dep.groups - cached.groups) - [:default]
            missing_platforms = as_dep.platforms - cached.platforms
            next if missing_groups.empty? && missing_platforms.empty?

            changed = true
            dep_cache[cached.name] = ::Bundler::Dependency.new(
              cached.name,
              nil,
              'group' => as_dep.groups | cached.groups,
              'platforms' => as_dep.platforms | cached.platforms,
            )

            dep_cache[cached.name]
          end
        end
        break unless changed
      end

      dep_cache
    end
  end
end