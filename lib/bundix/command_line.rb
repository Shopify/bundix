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

      lockfile = if (input = options.input).nil?
        if STDIN.tty?
          STDERR.puts(option_parser(options).help)
          exit(1)
        end
        T.must(STDIN.read)
      else
        ::File.read(input)
      end

      gemset = LockfileToGemset.call(
        lockfile: lockfile, caches: options.caches, concurrency: options.concurrency,
      )

      if (output = options.output).nil?
        # We need to be careful, in this mode, that this is the only thing we write to STDOUT.
        puts(gemset)
      else
        ::Bundix.atomic_write_file(output, gemset)
      end
    end

    private

    sig { returns(::Bundix::Options) }
    def parse_options
      opts = ::Bundix::Options.new
      option_parser(opts).parse!
      opts
    end

    sig { params(opts: ::Bundix::Options).returns(::OptionParser) }
    def option_parser(opts)
      ::OptionParser.new do |o|
        o.banner = <<~EOF
          Usage: bundix < Gemfile.lock > gemset.nix
                 bundix [-i <Gemfile.lock>] [-o <gemset.nix>]

        EOF

        o.on('-iPATH', '--input=PATH', 'read Gemfile.lock from a path rather than stdin') do |v|
          opts.input = ::File.expand_path(v)
        end

        o.on('-oPATH', '--output=PATH', 'write gemset.nix to a path rather than stdout') do |v|
          opts.output = ::File.expand_path(v)
        end

        o.on('-c', '--cache=~/.cache/bundix:/var/cache/bundix', 'paths to cache directories; only first will be written to') do |v|
          opts.caches = v.split(':').map { |p| ::File.expand_path(p) }
        end

        o.on('-nNUM', '--concurrency=8', 'number of gem fetches to do in parallel') do |v|
          opts.concurrency = Integer(v)
        end

        o.on('-q', '--quiet', 'suppress informational messages') { opts.quiet = true }

        o.on('-v', '--version', 'show the version of bundix') do
          puts(::Bundix::VERSION)
          exit
        end
      end
    end
  end
end
