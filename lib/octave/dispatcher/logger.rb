module Octave
  module Dispatcher
    class Logger < Base
      def initialize(logger = nil)
        @logger = logger
      end

      def call(payload)
        logger.info { "#{payload.name} took #{payload.duration}ms" }
      end

      def logger
        @logger || Octave.logger
      end
    end
  end
end
