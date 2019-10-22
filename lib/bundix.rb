# typed: strong
# frozen_string_literal: true
require('bundler')
require('json')
require('open3')

require('bundix/sorbet')

module Bundix
  autoload(:CommandLine,               'bundix/command_line')
  autoload(:Converter,                 'bundix/converter')
  autoload(:Fetcher,                   'bundix/fetcher')
  autoload(:Nixer,                     'bundix/nixer')
  autoload(:Options,                   'bundix/options')
  autoload(:Parallel,                  'bundix/parallel')
  autoload(:PlatformResolver,          'bundix/platform_resolver')
  autoload(:RebuildGemsetFromLockfile, 'bundix/rebuild_gemset_from_lockfile')
  autoload(:Source,                    'bundix/source')
  autoload(:Spec,                      'bundix/spec')
  autoload(:Unsafe,                    'bundix/unsafe')

  NIX_INSTANTIATE        = 'nix-instantiate'
  NIX_UNIVERSAL_PREFETCH = 'nix-universal-prefetch'
  NIX_HASH               = 'nix-hash'

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

  T_SPEC = T.type_alias { T.any(::Bundler::LazySpecification, ::Gem::Specification) }
  T_PLATFORM_SPEC = T.type_alias { T::Hash[String, String] }

  SHA256_32 = /^[a-z0-9]{52}$/

  class << self
    extend(T::Sig)

    sig { params(argv: T::Array[String]).returns(String) }
    def must_sh(argv)
      out, status = Bundix::Unsafe.open3_capture2e(argv)
      unless status.success?
        puts("$ #{argv.join(' ')}") unless $BUNDIX_QUIET
        puts(out) unless $BUNDIX_QUIET
        raise("command execution failed: #{status}")
      end
      out
    end
  end
end
