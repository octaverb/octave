module Octave
  module Dispatcher
    class Base
      # This method will be called evey time a Payload is dispatched.
      def call(_payload)
        raise NotImplementedError
      end

      # Close any necessary
      def close
        true
      end
    end
  end
end