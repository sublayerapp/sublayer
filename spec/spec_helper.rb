# frozen_string_literal: true

require "sublayer"
require "pry"
require "vcr"

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
end
