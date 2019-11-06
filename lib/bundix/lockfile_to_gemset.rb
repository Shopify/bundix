# typed: strong
# frozen_string_literal: true
require('bundix')

module Bundix
  # RebuildGemsetFromLockfile converts a Gemfile.lock into a gemset.nix. The major effort
  # here is obtaining sha256 hashes for each gem specified in the Gemfile.lock.
  #
  # Because fetching gems find hashes is expensive, we make use of parsed data
  # from an existing gemset.nix for any gems that are already shared by the
  # gemset.nix and the Gemfile.lock, and fetch only those that were newly
  # introduced.
  #
  # The end result is to write out a new gemset.nix to the provided gemset.nix
  # path, replacing the existing gemset, if one was provided.
  module LockfileToGemset
    extend(T::Sig)

    # Given the contents of a Gemfile.lock and a path to a directory that can
    # be used for caching between runs, return the text contents of a new
    # gemset.nix corresponding to the Gemfile.lock.
    sig { params(lockfile: String, cache: String, concurrency: Integer).returns(String) }
    def self.call(lockfile:, cache:, concurrency:)
      lockfile = ::Bundler::LockfileParser.new(lockfile)
      cache    = ::Bundix::Cache.new(cache)
      gemset   = ::Bundix::Converter.new(lockfile: lockfile, cache: cache).convert(concurrency: concurrency)
      ::Bundix::Nixer.serialize(gemset)
    end
  end
end
