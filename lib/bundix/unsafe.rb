# typed: strict
# frozen_string_literal: true
require('bundix')
require('open3')

module Bundix
  # Unsafe is a bag of all of the code that we can't make sorbet deal with at
  # `typed: strong`.
  module Unsafe
    extend(T::Sig)

    # This can't be strongly typed because sorbet won't let us use T.unsafe in
    # strongly-typed code, and it won't let us use unknown-length splats in any
    # level without T.unsafe.
    sig { params(argv: T::Array[String]).returns([String, String, Process::Status]) }
    def self.open3_capture3(argv)
      T.unsafe(::Open3).capture3(*argv)
    end

    # We can't really make any *actual* promises about the result of a JSON.parse.
    sig { params(json: String).returns(T.nilable(String)) }
    def self.sha256_from_json(json)
      ::JSON.parse(json)['sha256']
    end

    # It's probably possible to restructure the use-cases here to be accurately
    # typed, but it starts to turn into a big rabbit hole. In this case, we're
    # just promising that the key exists and maps to a string.
    sig { params(h: T::Hash[String, T.untyped], k: String).returns(String) }
    def self.fetch_string(h, k)
      h.fetch(k)
    end

    # We can't really make any *actual* promises about the result of a JSON.parse.
    sig { params(path: String).returns(T.nilable(T_GEMSET_ENTRY)) }
    def self.read_gemset_entry_as_json_from_file(path)
      ::JSON.parse(File.read(path))
    rescue Errno::ENOENT
      nil
    end
  end
end
