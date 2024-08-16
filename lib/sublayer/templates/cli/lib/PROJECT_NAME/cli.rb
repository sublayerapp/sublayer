# frozen_string_literal: true

module ProjectName
  class CLI < Thor
    ProjectName::Commands.constants.each do |command_class|
      command = ProjectName::Commands.const_get(command_class)
      desc command.command_name, command.description
      define_method(command.command_name) do |*args|
        command.new(options).execute(*args)
      end
    end
  end
end
