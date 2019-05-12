# Octave

Octave enables you to collect timing metrics on your application's performance.
Send your metrics to multiple sources.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "octave", "~> 0.1.0"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install octave

## Configuration

```ruby
Octave.configure do |config|
  # Set the maximum number of objects for the queue. Default is 1500
  config.max_queue = 2000
  # Enable/disable the agent. Default is true
  config.enabled = true
  # Set the logger. Default is Logger.new(STDOUT)
  config.logger = Logger.new(STDOUT)
  # Define your list of dispatchers. Default is [Octave::Dispatcher::Logger.new]
  config.dispatchers = [ Octave::Dispatcher::Logger.new ] 
end
```

If you're not using Rails, you'll need to manually start the Octave agent:

```ruby
Octave.start
```

## Usage

To measure the time it takes to execute a segment of code, Octave provides the
`Octave.measure` method.

```ruby
Octave.measure("metric-name") do
  process_credit_card
end
```

Octave will then push the measurement to each of your configured dispatchers.

### Using with Rails

Octave will automatically start the agent when integrated with a Rails
application (no need to call `Octave.start`).

#### Measuring actions

Include the `Octave::Helpers::Controller` module to add a method to log the time
it takes to execute each action. To log every action in your application:

```ruby
class ApplicationController < ActionController::Base
  include Octave::Helpers::Controller
  
  around_action :measure_action
end
```

That's it! If you want to change the metric name (controller_name.action_name,
by default), override the `measure_action_name` method.

```ruby
class ApplicationController < ActionController::Base
  include Octave::Helpers::Controller
  
  around_action :measure_action
  
  def measure_action_name
    "app.#{controller_name}.#{action_name}"
  end
end
```

## Dispatchers

Octave dispatchers receive the measurement payload to transform and persist the
data. Octave ships with an `Octave::Dispatcher::Logger` dispatcher which simply
sends the measurement to the configured logger (`Octave.config.logger`).

To configure your dispatchers:

```ruby
# Send the log output to a StringIO instance
logger_io = StringIO.new

Octave.configure do |config|
  config.dispatchers = [
    Octave::Dispatchers::Logger.new(Logger.new(logger_io))
  ]
end
``` 

## Creating a Dispatcher

Dispatchers only expect two instance methods: `call` and `close`. When a
measurement is dispatched, Octave sends the payload to each dispatcher's `call`
method.

When Octave is shutting down, `close` is used to close any open connections,
sockets, or perform any additional cleanup.

If we're wanting to log each measurement using puts, we can create a puts
dispatcher:

```ruby
class PutsDispatcher < Octave::Dispatcher::Base
  def call(payload)
    puts "#{payload.name} took #{payload.duration}ms to execute."
  end
end
```

For Octave to use the dispatcher, we'll need to enable it by adding it to the
array of dispatchers:

```ruby
Octave.configure do |config|
  config.dispatchers = [ PutsDispatcher.new ]
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/octaverb/octave. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Octave project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/octave/blob/master/CODE_OF_CONDUCT.md).
