# frozen_string_literal: true

require "tty-prompt"

module Projectname
  class CLI
    def self.start(args)
      new.run(args)
    end

    def run(args)
      command = args.shift

      case command
      when "example"
        example_command
      when "generate"
        generate_command
      when "help", nil
        display_help
      else
        puts "Unknown command: #{command}"
        display_help
      end
    end

    def example_command
      agent = ProjectName::Agents::ExampleAgent.new
      agent.run
    end

    def generate_command
      prompt = TTY::Prompt.new
      input = prompt.ask("What input would you like to give the generator?")
      generator = ProjectName::Generators::ExampleGenerator.new(input: input)
      result = generator.generate
      puts "Generated result: #{result}"
    end

    def display_help
      puts "Usage: #{File.basename($PROGRAM_NAME)} [command] [arguments]"
      puts "Commands:"
      puts "  example  Run the example agent"
      puts "  generate Run the example generator"
      puts "  help     Display this help message"
    end
  end
end
