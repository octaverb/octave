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

## Usage

TODO Write this

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/octaverb/octave. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Octave project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/octave/blob/master/CODE_OF_CONDUCT.md).
