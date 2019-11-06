# typed: strong
# frozen_string_literal: true
require('bundix')

module Bundix
  class Cache
    extend(T::Sig)

    sig { params(dir: String).void }
    def initialize(dir)
      @dir = T.let(dir, String)
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
      if (p = path(spec))
        ::Bundix::Unsafe.read_gemset_entry_as_json_from_file(p)
      end
    end

    sig { params(spec: ::Bundler::LazySpecification, entry: T_GEMSET_ENTRY).void }
    def set(spec, entry)
      if (p = path(spec))
        FileUtils.mkdir_p(@dir)
        ::Bundix.atomic_write_file(p, entry.to_json)
      end
    end

    sig { params(spec: ::Bundler::LazySpecification).returns(T.nilable(String)) }
    def path(spec)
      k = key(spec)
      return unless k
      File.join(@dir, "#{k}.json")
    end

    sig { params(spec: ::Bundler::LazySpecification).returns(T.nilable(String)) }
    def key(spec)
      name = T.must(spec.name)
      case (source = spec.source)
      when ::Bundler::Source::Git
        revision = ::Bundix::Unsafe.fetch_string(source.options, 'revision')
        "#{name}:git:#{revision}"
      when ::Bundler::Source::Rubygems
        "#{name}:gem:#{spec.version}"
      end # else nil
    end
  end
end
