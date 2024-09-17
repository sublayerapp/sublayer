class SublayerCommandGenerator < Sublayer::Generators::Base
    llm_output_adapter type: :named_strings,
      name: "sublayer_command",
      description: "The new command code based on the generator",
      attributes: [
        { name: "class_name", description: "The class name of the command" },
        { name: "description", description: "The description of the command" },
        { name: "execute_body", description: "The code inside the execute method" },
        { name: "filename", description: "The filename of the command, snake_cased with a .rb extension" }
      ]

    def initialize(generator_code:)
      @generator_code = generator_code
    end

    def generate
      super
    end

    def prompt
      <<-PROMPT
      You are an expert Ruby developer.

      Given the following Sublayer generator code:

      #{@generator_code}

      Please generate a Thor command class that interacts with this generator. The command should:

      - Be a subclass of `BaseCommand`.
      - Include a descriptive class name.
      - Provide a description for the command.
      - Implement an `execute` method that accepts appropriate arguments and invokes the generator.

      Provide the class name, description, execute method body, and filename for the command.

      These parameters will be used in a template to create the command file. The template is:
           module <%= project_name.camelize %>
       module Commands
         class <%= command_class_name %> < BaseCommand
           def self.description
             "<%= command_description %>"
           end

           def execute(*args)
             <%= command_execute_body %>
           end
         end
       end
     end

      Take into account any parameters the generator requires and map them to command-line arguments.
      PROMPT
    end
  end