# typed: true
# frozen_string_literal: true
require_relative('../test_helper')

require('digest')
require('json')

module Bundix
  class ConverterTest < MiniTest::Test
    class PrefetchStub < Bundix::Fetcher
      SPECS = {
        'sorbet-static' => {
          'platform' => 'java-123',
          'version' => '0.4.4821',
        },
      }

      def nix_prefetch_url(*args)
        format_hash(Digest::SHA256.hexdigest(args.to_s))
      end

      def nix_prefetch_git(*args)
        JSON.generate('sha256' => format_hash(Digest::SHA256.hexdigest(args.to_s)))
      end

      def fetch_local_hash(_spec, _)
        # Force to use fetch_remote_hash
        nil
      end

      def spec_for_dependency(_remote, name, version)
        opts = SPECS[name]
        raise("Unexpected spec query: #{name}") unless opts

        Gem::Specification.new do |s|
          s.name = name
          s.version = version
          s.platform = Gem::Platform.new(opts[:platform]) if opts[:platform]
        end
      end
    end

    def with_gemset(lockfile:)
      # Bundler.instance_variable_set(:@root, Pathname.new(File.expand_path('../data', __dir__)))
      cache = ::Bundix::Cache.new(['/tmp'])
      converter = Bundix::Converter.new(lockfile: ::Bundler::LockfileParser.new(::File.read(lockfile)), cache: cache)
      yield(converter.convert(concurrency: 8, fetcher: PrefetchStub.new))
      # ensure
      #   Bundler.reset!
    end

    def test_bundler_dep
      with_gemset(
        lockfile: File.expand_path('../data/bundler-audit/Gemfile.lock', __dir__)
      ) do |gemset|
        assert_equal('0.5.0', gemset.dig('bundler-audit', 'version'))
        assert_equal('0.19.4', gemset.dig('thor', 'version'))
        skip
        assert_equal('0.4.4821-java-unknown', gemset.dig('sorbet-static', 'version'))
      end
    end
  end
end
