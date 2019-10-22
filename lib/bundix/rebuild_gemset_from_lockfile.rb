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
  class RebuildGemsetFromLockfile
    extend(T::Sig)

    sig { params(lockfile: String, gemset: String).void }
    def initialize(lockfile:, gemset:)
      @lockfile_path = T.let(lockfile, String)
      @gemset_path   = T.let(gemset, String)
      @fetcher       = T.let(::Bundix::Fetcher.new, ::Bundix::Fetcher)
    end

    sig { void }
    def run
      lockfile   = ::Bundler::LockfileParser.new(::File.read(@lockfile_path))
      old_gemset = parse_gemset(@gemset_path)
      new_gemset = build_gemset(lockfile, old_gemset)
      write_gemset(new_gemset, @gemset_path)
    end

    private

    sig { params(path: String).returns(T_GEMSET) }
    def parse_gemset(path)
      return {} unless ::File.file?(path)
      json = ::Bundix.must_sh([::Bundix::NIX_INSTANTIATE, '--strict', '--eval', '--json', path])
      ::Bundix::Unsafe.gemset_from_json(json)
    end

    # Parse the lockfile and generate a new gemset data structure, using the
    # existing gemset to look up sha256 hashes where possible, rather than
    # re-fetching everything.
    sig { params(lockfile: ::Bundler::LockfileParser, previous_gemset: T_GEMSET).returns(T_GEMSET) }
    def build_gemset(lockfile, previous_gemset)
      ::Bundix::Converter.new(
        lockfile: lockfile,
        previous_gemset: previous_gemset,
      ).convert
    end

    # Serialize a gemset data structure (as a nix expression) and write it to
    # the provided gemset path, replacing an existing gemset if one was
    # provided.
    sig { params(gemset: T_GEMSET, path: String).void }
    def write_gemset(gemset, path)
      atomic_write_file(::Bundix::Nixer.serialize(gemset), path)
    end

    # "Atomically" write `contents` to `path`, by moving the file into place
    # after writing it elsewhere.
    sig { params(contents: String, path: String).void }
    def atomic_write_file(contents, path)
      tempfile = ::Tempfile.new('atomic-temp')
      begin
        tempfile.set_encoding(::Encoding::UTF_8)
        tempfile.write(contents)
        tempfile.flush
        ::FileUtils.mv(T.must(tempfile.path), path)
        ::FileUtils.chmod(0644, path)
      ensure
        tempfile.close!
        tempfile.unlink
      end
    end
  end
end
