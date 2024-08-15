require_relative "PROJECT_NAME/version"
require_relative "PROJECT_NAME/cli"
require_relative "PROJECT_NAME/agents/example_agent"
require_relative "PROJECT_NAME/generators/example_generator"
require_relative "PROJECT_NAME/actions/example_action"

module ProjectName
  class Error < StandardError; end

  def self.root
    File.dirname __dir__
  end
end
