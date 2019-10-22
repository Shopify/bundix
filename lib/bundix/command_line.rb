# typed: strong
# frozen_string_literal: true
require('bundix')
require('optparse')
require('tempfile')

module Bundix
  # Unlike upstream bundix, we only have one mode: regenerate the gemset.nix
  # given a Gemfile.lock.
  class CommandLine
    extend(T::Sig)

    sig { void }
    def self.run
      new.run
    end

    sig { void }
    def run
      options = parse_options
      $BUNDIX_QUIET = options.quiet
      RebuildGemsetFromLockfile.new(lockfile: options.lockfile, gemset: options.gemset).run
    end

    private

    sig { returns(::Bundix::Options) }
    def parse_options
      opts = ::Bundix::Options.new
      ::OptionParser.new do |o|
        o.on("--gemset=#{opts.gemset}", 'path to gemset.nix') { |v| opts.gemset = ::File.expand_path(v) }
        o.on("--lockfile=#{opts.lockfile}", 'path to Gemfile.lock') { |v| opts.lockfile = ::File.expand_path(v) }
        o.on('-q', '--quiet', 'only output errors') { opts.quiet = true }
        o.on('-v', '--version', 'show the version of bundix') do
          puts(::Bundix::VERSION)
          exit
        end
      end.parse!
      opts
    end
  end
end
