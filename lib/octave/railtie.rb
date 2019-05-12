module Octave
  class Railtie < Rails::Railtie #:nodoc:
    config.after_initialize do
      Octave.start
    end
  end
end
