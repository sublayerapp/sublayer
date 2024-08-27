require "thor"
require "sublayer/version"
require "yaml"
require "fileutils"
require "active_support/inflector"

require_relative "cli/commands/new_project"

module Sublayer
  class CLI < Thor

    register(Sublayer::Commands::NewProject, "new", "new PROJECT_NAME", "Creates a new Sublayer project")

    desc "version", "Prints the Sublayer version"
    def version
      puts Sublayer::VERSION
    end
  end
end
