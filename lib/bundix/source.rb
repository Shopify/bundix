# typed: strong
# frozen_string_literal: true
require('bundix')
require('bundler')
require('json')
require('rubygems/platform')

module Bundix
  # Note that output generated here has newlines tacked to the end of it, since
  # this is run in parallel and otherwise we could get ugly interleaving.
  module Source
    class << self
      extend(T::Sig)

      sig { params(spec: ::Bundler::LazySpecification, fetcher: ::Bundix::Fetcher).returns([String, Spec::Source::TYPE]) }
      def convert(spec, fetcher)
        case (source = spec.source)
        when ::Bundler::Source::Rubygems
          convert_rubygems(spec, source, fetcher)
        when ::Bundler::Source::Git
          convert_git(spec, source, fetcher)
        when ::Bundler::Source::Path
          convert_path(spec, source)
        else
          STDERR.puts("#{spec.inspect}\n")
          raise('unknown bundler source')
        end
      end

      private

      sig { params(spec: ::Bundler::LazySpecification, source: ::Bundler::Source::Path).returns([String, Spec::Source::PATH_TYPE]) }
      def convert_path(spec, source)
        [spec.version.to_s, {
          'type' => 'path',
          'path' => source.path?.to_s,
        }]
      end

      sig { params(spec: ::Bundler::LazySpecification, source: ::Bundler::Source::Rubygems, fetcher: ::Bundix::Fetcher).returns([String, Spec::Source::GEM_TYPE]) }
      def convert_rubygems(spec, source, fetcher)
        remotes = source.remotes.map { |remote| remote.to_s.sub(%r{/+$}, '') }
        remote, hash, platform = fetcher.prefetch_from_gemservers(spec, remotes)
        raise("couldn't fetch hash for #{spec.full_name}") unless hash

        version = spec.version.to_s
        if platform && platform != ::Gem::Platform::RUBY
          version += "-#{platform}"
        end

        STDERR.puts("#{hash} => #{spec.name}-#{version}.gem\n") unless $BUNDIX_QUIET

        [version, {
          'type' => 'gem',
          'remotes' => (remote ? [remote] : remotes),
          'sha256' => hash,
        }]
      end

      sig do
        params(spec: ::Bundler::LazySpecification, source: ::Bundler::Source::Git, fetcher: ::Bundix::Fetcher)
          .returns([String, Spec::Source::GIT_TYPE])
      end
      def convert_git(spec, source, fetcher)
        options = source.options
        revision = ::Bundix::Unsafe.fetch_string(options, 'revision')
        uri = ::Bundix::Unsafe.fetch_string(options, 'uri')
        submodules = !!source.submodules
        json = fetcher.prefetch_git_repo(uri, revision, submodules: submodules)
        hash = ::Bundix::Unsafe.sha256_from_json(json)
        raise("invalid git prefetch output for #{spec.full_name}: #{hash}") unless hash && hash =~ Fetcher::SHA256_32
        STDERR.puts("#{hash} => #{uri}\n") unless $BUNDIX_QUIET

        [spec.version.to_s, {
          'type' => 'git',
          'url' => uri.to_s,
          'rev' => revision,
          'sha256' => hash,
          'fetchSubmodules' => submodules,
        }]
      end
    end
  end
end
