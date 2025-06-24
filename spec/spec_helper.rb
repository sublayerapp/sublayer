# frozen_string_literal: true

require "dotenv/load"

unless ENV["OPENAI_API_KEY"] && ENV["ANTHROPIC_API_KEY"] && ENV["GEMINI_API_KEY"]
  puts <<~EOS
    Some API keys are missing from the environment.
    You can run `bin/setup` to configure dummy API keys.
    If you need to add or update any VCR cassettes then you will need to use real keys.
  EOS
  exit(1)
end

require "sublayer"
require "pry"
require "vcr"
require_relative "../lib/sublayer/cli"

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data("<OPENAI_API_KEY>") { ENV.fetch("OPENAI_API_KEY") }
  config.filter_sensitive_data("<ANTHROPIC_API_KEY>") { ENV.fetch("ANTHROPIC_API_KEY") }
  config.filter_sensitive_data("<GEMINI_API_KEY>") { ENV.fetch("GEMINI_API_KEY") }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.after(:suite) do
    FileUtils.rm_rf(File.expand_path('../tmp', __dir__))
  end
end
