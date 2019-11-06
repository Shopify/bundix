# typed: strict
# frozen_string_literal: true
require('bundix')

module Bundix
  # Converter converts a Gemfile.lock (Bundler::LockfileParser) into a gemset.nix data structure
  # (T_GEMSET), using a cache to prevent as many fetches as possible.
  class Converter
    extend(T::Sig)

    sig { params(lockfile: ::Bundler::LockfileParser, cache: ::Bundix::Cache).void }
    def initialize(lockfile:, cache:)
      @lockfile = T.let(lockfile, ::Bundler::LockfileParser)
      @cache = T.let(cache, ::Bundix::Cache)
    end

    sig { params(concurrency: Integer, fetcher: ::Bundix::Fetcher).returns(T_GEMSET) }
    def convert(concurrency:, fetcher: ::Bundix::Fetcher.new)
      dep_cache = build_depcache(@lockfile)

      gemset = T.let({}, T_GEMSET)
      mutex = Mutex.new
      Parallel.each_spec(@lockfile.specs, concurrency: concurrency) do |spec|
        name = T.must(spec.name)
        entry = fetch_or_build_entry(spec, fetcher, dep_cache)
        mutex.synchronize { gemset[name] = entry }
      end
      gemset
    end

    private

    sig do
      params(
        spec: ::Bundler::LazySpecification, # Given a gem specification
        fetcher: ::Bundix::Fetcher, # or build one by fetching the remote if necessary
        dep_cache: T::Hash[String, ::Bundler::Dependency] # and assign the correct dependencies.
      ).returns(T_GEMSET_ENTRY) # Return this in the format that we'll serialize into gemset.nix.
      # Importantly, note that this is run concurrently, so any output generated should be careful
      # to not look bad in that context.
    end
    def fetch_or_build_entry(spec, fetcher, dep_cache)
      @cache.fetch(spec) do
        dep = dep_cache.fetch(T.must(spec.name))
        generate_uncached_entry(spec, fetcher, dep)
      end
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
        'dependencies' => spec.dependencies.map(&:name) - ['bundler'],
        'platforms' => ::Bundix::PlatformResolver.resolve(dep.platforms),
        'groups' => dep.groups.map(&:to_s),
        'version' => version,
        'source' => source,
      }
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
