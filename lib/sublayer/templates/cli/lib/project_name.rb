require "yaml"
require "thor"
require "sublayer"
require_relative "PROJECT_NAME/version"
require_relative "PROJECT_NAME/config"

Dir[File.join(__dir__, "PROJECT_NAME", "commands", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "PROJECT_NAME", "generators", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "PROJECT_NAME", "actions", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "PROJECT_NAME", "agents", "*.rb")].each { |file| require file }

require_relative "PROJECT_NAME/cli"

module ProjectName
  class Error < StandardError; end
  Config.load

  def self.root
    File.dirname __dir__
  end
end
