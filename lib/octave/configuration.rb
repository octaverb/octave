require "logger"

module Octave
  # Handle the configuration of the Octave agent.
  class Configuration
    # Maximum size of the queue. Default is 1500
    # @return [Numeric]
    attr_accessor :max_queue

    # Logger to be used for logging events and debugging. Default is
    # <tt>Logger.new(STDOUT)</tt>.
    attr_accessor :logger

    # Array of dispatchers to be used once a <tt>Payload</tt> has been
    # completed. Default is <tt>[Octave::Dispatcher::Logger.new]</tt>.
    # @return [Array] Array containing dispatchers
    attr_writer :dispatchers

    # Enable the agent. Default is true.
    attr_writer :enabled

    def initialize
      @max_queue = 1500
      @logger = Logger.new(STDOUT)
      @enabled = true
    end

    def dispatchers
      @dispatchers ||= [
        Octave::Dispatcher::Logger.new
      ]
    end

    # @return [Boolean] Whether or not the agent is enabled
    def enabled?
      @enabled
    end
  end
end