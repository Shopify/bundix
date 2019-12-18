# typed: strong
# frozen_string_literal: true
require('bundix')

module Bundix
  class Options
    extend(T::Sig)

    sig { void }
    def initialize
      @output      = T.let(nil, T.nilable(String))
      @input       = T.let(nil, T.nilable(String))
      @caches      = T.let([File.expand_path('~/.cache/bundix')], T::Array[String])
      @quiet       = T.let(false, T::Boolean)
      @concurrency = T.let(1, Integer)
    end

    sig { params(input: T.nilable(String)).void }
    attr_writer(:input)
    sig { returns(T.nilable(String)) }
    attr_reader(:input)

    sig { params(output: T.nilable(String)).void }
    attr_writer(:output)
    sig { returns(T.nilable(String)) }
    attr_reader(:output)

    sig { params(caches: T::Array[String]).void }
    attr_writer(:caches)
    sig { returns(T::Array[String]) }
    attr_reader(:caches)

    sig { params(concurrency: Integer).void }
    attr_writer(:concurrency)
    sig { returns(Integer) }
    attr_reader(:concurrency)

    sig { params(quiet: T::Boolean).void }
    attr_writer(:quiet)
    sig { returns(T::Boolean) }
    attr_reader(:quiet)
  end
end
