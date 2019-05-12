module Octave
  module Helpers
    # Helpers to include in your Rails controllers to automatically collect
    # metrics on how long it takes to complete an action.
    #
    # == Example
    #   class PostsController < ActionController::Base
    #     include Octave::Helpers::Controller
    #
    #     around_action :measure_action
    #   end
    module Controller
      # Measures the duration of the action.
      #
      # == Example
      #   around_action :measure_action, only: %i[create update destroy]
      def measure_action(&block)
        Octave.measure(measure_action_name, &block)
      end

      # The name of the metric. Default is
      # <tt>#{controller_name}.#{action_name}</tt>. Override this method if
      # you would like to specify your own name.
      def measure_action_name
        [controller_name, action_name].join(".")
      end
    end
  end
end