# typed: strong
# frozen_string_literal: true
require('bundix')

module Bundix
  class Cache
    extend(T::Sig)

    sig { params(dirs: T::Array[String]).void }
    def initialize(dirs)
      @dirs = T.let(dirs, T::Array[String])
      @first_dir = T.let(T.must(dirs.first), String)
    end

    sig do
      params(
        spec: ::Bundler::LazySpecification,
        block: T.proc.returns(T_GEMSET_ENTRY)
      ).returns(T_GEMSET_ENTRY)
    end
    def fetch(spec, &block)
      if (entry = get(spec))
        return(entry)
      end
      entry = block.call
      set(spec, entry)
      entry
    end

    private

    sig { params(spec: ::Bundler::LazySpecification).returns(T.nilable(T_GEMSET_ENTRY)) }
    def get(spec)
      read_paths(spec).each do |p|
        x = ::Bundix::Unsafe.read_gemset_entry_as_json_from_file(p)
        return x if x
      end
      nil
    end

    sig { params(spec: ::Bundler::LazySpecification, entry: T_GEMSET_ENTRY).void }
    def set(spec, entry)
      if (p = write_path(spec))
        FileUtils.mkdir_p(@first_dir)
        ::Bundix.atomic_write_file(p, entry.to_json)
      end
    end

    sig { params(spec: ::Bundler::LazySpecification).returns(T.nilable(String)) }
    def write_path(spec)
      k = key(spec)
      return unless k
      File.join(@first_dir, "#{k}.json")
    end

    sig { params(spec: ::Bundler::LazySpecification).returns(T::Array[String]) }
    def read_paths(spec)
      k = key(spec)
      return [] unless k
      @dirs.map { |dir| File.join(dir, "#{k}.json") }
    end

    sig { params(spec: ::Bundler::LazySpecification).returns(T.nilable(String)) }
    def key(spec)
      # When the ruby architecture changes, the cache becomes invalid for
      # platform-specific gems.
      platform_key = if spec.platform != Gem::Platform::RUBY
        ":#{spec.platform}:#{Gem.platforms.map(&:to_s).join(';')}"
      else
        nil
      end

      name = T.must(spec.name)
      case (source = spec.source)
      when ::Bundler::Source::Git
        revision = ::Bundix::Unsafe.fetch_string(source.options, 'revision')
        "#{name}:git:#{revision}#{platform_key}"
      when ::Bundler::Source::Rubygems
        "#{name}:gem:#{spec.version}#{platform_key}"
      end # else nil
    end
  end
end
