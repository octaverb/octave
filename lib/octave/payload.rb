module Octave
  # A Payload contains information about each metric and the time to complete.
  # After each Payload has been completed, it will be sent to each dispatcher.
  #
  # To manually create a payload and send it to the dispatcher:
  #   payload = Payload.new("name-of-event")
  #   expensive_method
  #   payload.done
  #   Octave.dispatch(payload)
  class Payload
    attr_reader :name, :options, :start_time, :end_time

    # Creates a new Payload.
    #
    # @param name [String] The name of the metric
    # @param options [Hash] Hash containing options. Useful for passing to dispatchers
    def initialize(name, options = {})
      @start_time = Time.now
      @name       = name
      @options    = options
    end

    # Call this method immediately after the work has been completed.
    def done
      @end_time = Time.now
    end

    # Duration of the metric in milliseconds.
    def duration
      return if end_time.nil?

      (end_time - start_time) * 1000.0
    end
  end
end