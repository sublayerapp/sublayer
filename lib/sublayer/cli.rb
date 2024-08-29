require "thor"

require "sublayer"
require "sublayer/version"
require "yaml"
require "fileutils"
require "active_support/inflector"

require_relative "cli/commands/subcommand_base"
require_relative "cli/commands/new_project"
require_relative "cli/commands/generator"
require_relative "cli/commands/agent"
require_relative "cli/commands/action"

module Sublayer
  class CLI < Thor

    register(Sublayer::Commands::NewProject, "new", "new PROJECT_NAME", "Creates a new Sublayer project")

    register(Sublayer::Commands::Generator, "generate:generator", "generate:generator", "Generates a new Sublayer::Generator subclass for your project")
    register(Sublayer::Commands::Agent, "generate:agent", "generate:agent", "Generates a new Sublayer::Agent subclass for your project")
    register(Sublayer::Commands::Action, "generate:action", "generate:action", "Generates a new Sublayer::Action subclass for your project")

    desc "version", "Prints the Sublayer version"
    def version
      puts Sublayer::VERSION
    end

    desc "help [COMMAND]", "Describe available commands or one specific command"
    def help(command = nil, subcommand = false)
      if command.nil?
        puts "Sublayer CLI"
        puts
        puts "Usage:"
        puts "  sublayer COMMAND [OPTIONS]"
        puts
        puts "Commands:"
        print_commands(self.class.commands.reject { |name, _| name == "help" || name == "version" })
        puts
        print_commands(self.class.commands.select { |name, _| name == "help" })
        print_commands(self.class.commands.select { |name, _| name == "version" })
        puts
        puts "Run 'sublayer COMMAND --help' for more information on a command."
      else
        super
      end
    end

    default_command :help

    private

    def print_commands(commands)
      commands.each do |name, command|
        puts "  #{name.ljust(15)} # #{command.description}"
      end
    end
  end
end
