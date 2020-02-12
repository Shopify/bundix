# typed: strong
# frozen_string_literal: true
require('bundix')

module Bundix
  module DepCache
    extend(T::Sig)

    sig { params(lock: ::Bundler::LockfileParser).returns(T::Hash[String, ::Bundler::Dependency]) }
    def self.build(lock)
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
