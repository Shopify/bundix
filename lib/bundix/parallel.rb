# typed: strict
# frozen_string_literal: true
require('bundix')

module Bundix
  module Parallel
    class << self
      extend(T::Sig)

      sig do
        # Sorbet doesn't propagate the types correctly :(
        # type_parameters(:U)
        #   .params(
        #     collection: T::Array[T.type_parameter(:U)],
        #     block: T.proc.params(arg0: T.type_parameter(:U)).void
        #   ).void
        #
        # So unfortunately here's a specialized signature:
        params(
          collection: T::Array[::Bundler::LazySpecification], # Iterate through a collection of specs
          concurrency: Integer, # ...concurrently...
          block: T.proc.params(arg0: ::Bundler::LazySpecification).void # and yield each (concurrently)
        ).void # Returns when all blocks are done executing.
        # TODO: What if this crashes?
      end
      def each_spec(collection, concurrency: 16, &block)
        mutex = Mutex.new
        concurrency = [concurrency, collection.size].min

        threads = concurrency.times.map do
          Thread.new do
            loop do
              break unless (spec = mutex.synchronize { collection.pop })
              block.call(spec)
            end
          end
        end
        threads.map(&:join)
      end
    end
  end
end
