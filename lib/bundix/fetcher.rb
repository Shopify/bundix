# typed: strong
# frozen_string_literal: true
require('bundix')
require('bundler')
require('uri')
require('net/http')
require('fileutils')
require('rubygems')

module Bundix
  # Fetcher is a small collection of methods to prefetch various resource types into the nix store
  # and return the corresponding hashes.
  class Fetcher
    extend(T::Sig)

    sig do
      params(
        spec: ::Bundler::LazySpecification, # Given a (proxy for a) Gem Specification
        remotes: T::Array[String],          # and a list of possible remotes...
      ).returns(
        # check each remote for an available gem matching the specification
        # and, if found, return three values:
        T.nilable([
          String,            # The provided remote on which the gem was found
          String,            # The base32-formatted sha256 hash of the download
          T.nilable(String), # The target platform of the gem, if applicable.
        ])
        # Note that typically the platform won't be specified: This is just for
        # platform-specific gems (sorbet-static being a prime example).
      )
    end
    def prefetch_from_gemservers(spec, remotes)
      remotes.each do |remote|
        hash, platform = try_prefetch_from_gemserver(spec, remote)
        return remote, format_hash(hash), platform if hash
      end
      nil
    end

    sig do
      params(
        uri: String, # Given a git repo URI
        revision: String, # and a target revision
        submodules: T::Boolean # (should we recurse into submodules too?)
      ).returns(String) # prefetch the repo into the nix store, return sha256 hash
    end
    def prefetch_git_repo(uri, revision, submodules: false)
      args = [
        'fetchRubyGem',
        '--type', 'git',
        '--url', uri,
        '--rev', revision
      ]
      args << '--fetch-submodules' << 'true' if submodules

      out, err, stat = ::Bundix::Unsafe.open3_capture3([::Bundix::NIX_UNIVERSAL_PREFETCH, *args])
      unless stat.success?
        raise("unable to fetch git repo at #{uri} (revision #{revision}: #{err}")
      end
      out
    end

    private

    sig do
      params(
        spec: ::Bundler::LazySpecification, # Given a (proxy for a) gemspec
        remote: String, # and a single candidate remote
      ).returns(
        # Try to fetch the gem from the remote, returning, if found:
        T.nilable([
          String, # The base32-encoded sha256 hash; and
          T.nilable(String), # the target platform, if applicable.
        ])
      )
    end
    def try_prefetch_from_gemserver(spec, remote)
      has_platform = spec.platform && spec.platform != ::Gem::Platform::RUBY
      if has_platform
        spec = spec_for_dependency(remote, T.must(spec.name), spec.version)
        return unless spec
      end

      uri = "#{remote}/gems/#{spec.full_name}.gem"
      result = nix_prefetch_url(uri)
      return unless result # 404

      [T.must(result[::Bundix::SHA256_32]), spec.platform&.to_s]
    end

    # Prefetch a URL, returning the base32-encoded sha256 hash if successful.
    # If the return is nil, we 404'd, and should try other remotes, if any.
    sig { params(url: String).returns(T.nilable(String)) }
    def nix_prefetch_url(url)
      out, err, stat = ::Bundix::Unsafe.open3_capture3([
        ::Bundix::NIX_UNIVERSAL_PREFETCH,
        'fetchRubyGem',
        '--type', 'url',
        '--name', ::File.basename(url), # --name mygem-1.2.3.gem
        '--url', url
      ])
      unless stat.success?
        if err.include?(' 404 Not Found')
          return(nil)
        else
          raise("nix-universal-prefetch failed: #{err}")
        end
      end
      out.force_encoding(::Encoding::UTF_8).strip
    end

    # format a sha256 hash in the base32-encoded format that nix likes to use.
    sig { params(hash: String).returns(String) }
    def format_hash(hash)
      out = ::Bundix.must_sh([NIX_HASH, '--type', 'sha256', '--to-base32', hash])
      T.must(out[::Bundix::SHA256_32])
    end

    # Fetch remote spec to determine the exact platform
    # Note that we can't simply use the local platform; the platform of the gem might differ.
    # e.g. universal-darwin-14 covers x86_64-darwin-14
    sig { params(remote: String, name: String, version: ::Gem::Version).returns(T.nilable(::Gem::Specification)) }
    def spec_for_dependency(remote, name, version)
      sources = ::Gem::SourceList.from([remote])
      spec_fetcher = ::Gem::SpecFetcher.new(sources)
      dep = ::Gem::Dependency.new(name, version)
      specs_with_sources, _ = spec_fetcher.spec_for_dependency(dep)
      spec, _ = specs_with_sources.first
      spec
    end
  end
end