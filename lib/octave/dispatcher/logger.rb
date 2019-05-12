module Octave
  module Dispatcher
    class Logger < Base
      def new(logger = nil)
        @logger = logger
      end

      def call(payload)
        logger.info { "#{payload.name} took #{payload.duration}ms" }
      end

      private

      def logger
        @logger || Octave.logger
      end
    end
  end
end