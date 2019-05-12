require "octave/version"
require "octave/configuration"
require "octave/dispatcher/base"
require "octave/dispatcher/logger"
require "octave/payload"
require "octave/agent"

if defined?(Rails)
  require "octave/helpers/controller"
  require "octave/railtie"
end

module Octave #:nodoc:
  class << self
    attr_writer :config

    # Configures Octave. See <tt>Octave::Configuration</tt> for configuration
    # options.
    #
    # == Example
    #   Octave.configure do |config|
    #     config.logger = Rails.logger
    #   end
    def configure
      self.config ||= Configuration.new
      yield(config)
    end

    # @return [Configuration] The current Octave configuration
    def config
      @config ||= Configuration.new
    end

    # Resets the configuration to the default
    def reset_config
      @config = nil
    end

    # Shortcut method to access <tt>Octave.config.logger</tt>.
    def logger
      Octave.config.logger
    end

    # Measure the performance of a block.
    #
    # == Example
    #   Octave.measure("process-card") do
    #     process_credit_card
    #   end
    def measure(name, options = {})
      payload = Payload.new(name, options)
      result  = yield

      dispatch(payload.tap(&:done))
      result
    end

    # Dispatches the payload to the current agent
    def dispatch(payload)
      agent.dispatch(payload) if agent.running?
    end

    # Starts the agent
    def start
      agent.start
    end

    # Stops the agent
    def stop
      agent.stop
      @agent = nil
    end

    private

    def agent
      @agent ||= Agent.new
    end
  end
end
