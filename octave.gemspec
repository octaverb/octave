lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "octave/version"

Gem::Specification.new do |spec|
  spec.name          = "octave"
  spec.version       = Octave::VERSION
  spec.authors       = ["Drew Tempelmeyer"]
  spec.email         = ["drewtempelmeyer@users.noreply.github.com"]

  spec.summary       = "Collect application performance metrics."
  spec.description   = "Collect application performance metrics."
  spec.homepage      = "https://github.com/octaverb/octave"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/octaverb/octave"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.68.1"
  spec.add_development_dependency "rubocop-performance", "~> 1.2.0"
  spec.add_development_dependency "timecop", "~> 0.9.1"
end
