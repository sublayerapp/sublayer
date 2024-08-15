# frozen_string_literal: true

require "bundler/setup"
Bundler.require(:default, ENV['RACK_ENV'] || 'development')

require 'yaml'
require 'sublayer'

config_path = File.join(__dir__, '..', 'sublayer.yml')
if File.exist?(config_path)
  config = YAML.load_file(config_path)

  Sublayer.configure do |c|
    c.ai_provider = Object.const_get("Sublayer::Providers::#{config['ai_provider']}")
    c.ai_model = config['ai_model'] if config['ai_model']

    c.logger = Sublayer::Logging::JsonLogger.new(File.join(__dir__, "..", "log", "sublayer.log"))
  end
else
  puts "Warning: sublayer.yml configuration file not found. Using default configuration."
end

Dir[File.join(__dir__, '..', 'app', '**', "*.rb")].sort.each { |file| require file }

