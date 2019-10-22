# typed: strong
# frozen_string_literal: true
require('bundix')

module Bundix
  class Options
    extend(T::Sig)

    sig { void }
    def initialize
      @lockfile = T.let('Gemfile.lock', String)
      @gemset   = T.let('gemset.nix', String)
      @quiet    = T.let(false, T::Boolean)
    end

    sig { params(lockfile: String).void }
    attr_writer(:lockfile)
    sig { returns(String) }
    attr_reader(:lockfile)

    sig { params(gemset: String).void }
    attr_writer(:gemset)
    sig { returns(String) }
    attr_reader(:gemset)

    sig { params(quiet: T::Boolean).void }
    attr_writer(:quiet)
    sig { returns(T::Boolean) }
    attr_reader(:quiet)
  end
end
