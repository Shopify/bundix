# typed: strict
# frozen_string_literal: true
require('bundix')
require('open3')

module Bundix
  module Unsafe
    extend(T::Sig)

    sig { params(argv: T::Array[String]).returns([String, Process::Status]) }
    def self.open3_capture2e(argv)
      T.unsafe(::Open3).capture2(*argv)
    end

    sig { params(argv: T::Array[String]).returns([String, String, Process::Status]) }
    def self.open3_capture3(argv)
      T.unsafe(::Open3).capture3(*argv)
    end

    sig { params(json: String).returns(T.nilable(String)) }
    def self.sha256_from_json(json)
      ::JSON.parse(json)['sha256']
    end

    sig { params(h: T::Hash[String, T.untyped], k: String).returns(String) }
    def self.fetch_string(h, k)
      h.fetch(k)
    end

    sig { params(h: ::Bundler::Settings, k: String).returns(T.nilable(String)) }
    def self.get_bundler_setting(h, k)
      h[k]
    end

    sig { params(path: String).returns(T.nilable(T_GEMSET_ENTRY)) }
    def self.read_gemset_entry_as_json_from_file(path)
      ::JSON.parse(File.read(path))
    rescue Errno::ENOENT
      nil
    end
  end
end
