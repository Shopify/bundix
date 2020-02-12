# typed: strong
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
      dep_cache = ::Bundix::DepCache.build(@lockfile)

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
    end
  end
end
