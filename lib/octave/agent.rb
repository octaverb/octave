module Octave
  # The agent handles managing the queue and dispatching the payload to each
  # configured dispatcher.
  class Agent
    def initialize
      @queue   = SizedQueue.new(Octave.config.max_queue)
      @running = false

      at_exit(&method(:stop))
    end

    # Adds the payload to the queue.
    #
    # @param payload [Payload] the payload to be added to the queue.
    def dispatch(payload)
      queue.push(payload)
    end

    # Start the agent process and begin dispatching events.
    def start
      unless Octave.config.enabled?
        Octave.logger.warn do
          "Octave agent is disabled. Metrics will not be reported."
        end

        return
      end

      Octave.logger.info { "Starting Octave agent..." }

      @thread = Thread.new(&method(:run))
      @running = true
    end

    # Loop to pass the payload to each dispatcher as the payload enters the
    # queue.
    def run
      while running? || !queue.empty?
        payload = queue.pop(false)
        call_dispatchers(payload)
      end
    end

    # Stop the agent.
    def stop
      return unless running?

      @queue.close
      @thread.exit
      dispatchers.each(&:close)
      @running = false

      true
    end

    # Determines whether the agent is running.
    #
    # @return [Boolean]
    def running?
      @running
    end

    private

    attr_reader :queue

    # Submits the payload to each dispatcher.
    def call_dispatchers(payload)
      dispatchers.each do |dispatcher|
        dispatcher.call(payload)
      end
    end

    def dispatchers
      Octave.config.dispatchers
    end
  end
end
