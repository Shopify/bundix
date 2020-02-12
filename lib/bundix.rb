# typed: strong
# frozen_string_literal: true
require('bundler')
require('json')
require('open3')

require('bundix/sorbet')

module Bundix
  autoload(:Cache,            'bundix/cache')
  autoload(:CommandLine,      'bundix/command_line')
  autoload(:Converter,        'bundix/converter')
  autoload(:DepCache,         'bundix/dep_cache')
  autoload(:Fetcher,          'bundix/fetcher')
  autoload(:LockfileToGemset, 'bundix/lockfile_to_gemset')
  autoload(:Nixer,            'bundix/nixer')
  autoload(:Options,          'bundix/options')
  autoload(:Parallel,         'bundix/parallel')
  autoload(:PlatformResolver, 'bundix/platform_resolver')
  autoload(:Source,           'bundix/source')
  autoload(:Spec,             'bundix/spec')
  autoload(:Unsafe,           'bundix/unsafe')

  NIX_HASH = 'nix-hash'

  T_GEMSET_ENTRY = T.type_alias do
    {
      'dependencies' => T::Array[String],
      'platforms' => T::Array[T_PLATFORM_SPEC],
      'groups' => T::Array[String],
      'version' => String,
      'source' => Bundix::Spec::Source::TYPE,
    }
  end
  T_GEMSET = T.type_alias { T::Hash[String, T_GEMSET_ENTRY] }
  T_PLATFORM_SPEC = T.type_alias { T::Hash[String, String] }

  class << self
    extend(T::Sig)

    # "Atomically" write `contents` to `path`, by moving the file into place
    # after writing it elsewhere.
    sig { params(path: String, contents: String).void }
    def atomic_write_file(path, contents)
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
