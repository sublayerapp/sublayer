# frozen_string_literal: true

require_relative "lib/sublayer/version"

Gem::Specification.new do |spec|
  spec.name = "sublayer"
  spec.version = Sublayer::VERSION
  spec.authors = ["Scott Werner"]
  spec.email = ["scott@sublayer.com"]
  spec.license = "MIT"

  spec.summary = "A ruby library for interacting with and orchestrating AI agents"
  spec.description = "A command line framework for building, generating, and orchestrating AI agents."
  spec.homepage = "https://www.sublayer.com"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end

  spec.executables << "sublayer"
  spec.executables << "sublayer_simple_tdd_pair"
  spec.require_paths = ["lib"]

  spec.add_dependency "ruby-openai"
  spec.add_dependency "colorize"
  spec.add_dependency "activesupport"
  spec.add_dependency "zeitwerk"
  spec.add_dependency "nokogiri"
  spec.add_dependency "httparty"

  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "pry", " ~> 0.14"
end
