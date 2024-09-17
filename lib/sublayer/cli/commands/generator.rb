require_relative "generators/sublayer_generator_generator"
require_relative "generators/sublayer_command_generator"

module Sublayer
  module Commands
    class Generator < Thor::Group
      include Thor::Actions

      class_option :description, type: :string, desc: "Description of the generator you want to generate", aliases: :d
      class_option :provider, type: :string, desc: "AI provider (OpenAI, Claude, or Gemini)", aliases: :p
      class_option :model, type: :string, desc: "AI model name to use (e.g. gpt-4o, claude-3-haiku-20240307, gemini-1.5-flash-latest)", aliases: :m
      class_option :generate_command, type: :boolean, desc: "Generate a command for the new generator", aliases: :c

      def self.banner
        "sublayer generate:generator"
      end

      def self.source_root
        File.expand_path("../../templates", __FILE__)
      end

      def confirm_usage_of_ai_api
        puts "You are about to generate a new generator that uses an AI API to generate content."
        puts "Please ensure you have the necessary API keys and that you are aware of the costs associated with using the API."
        exit unless yes?("Do you want to continue?")
      end

      def determine_available_providers
        @available_providers = []

        @available_providers << "OpenAI" if ENV["OPENAI_API_KEY"]
        @available_providers << "Claude" if ENV["ANTHROPIC_API_KEY"]
        @available_providers << "Gemini" if ENV["GEMINI_API_KEY"]
      end

      def ask_for_generator_details
        @description = options[:description] || ask("Enter a description for the Sublayer Generator you'd like to create:")
        @ai_provider = options[:provider] || ask("Select an AI provider:", default: "OpenAI", limited_to: @available_providers)
        @ai_model = options[:model] || select_ai_model

        if is_cli_project? && options[:generate_command].nil?
          @generate_command = yes?("Would you like to create a corresponding CLI command for this generator?")
        end
      end

      def generate_generator
        Sublayer.configuration.ai_provider = Object.const_get("Sublayer::Providers::#{@ai_provider}")
        Sublayer.configuration.ai_model = @ai_model

        say "Generating Sublayer Generator..."
        @results = SublayerGeneratorGenerator.new(description: @description).generate
      end

      def determine_destination_folder
        # Find either a ./generators folder or a generators folder nested one level below ./lib
        @destination_folder = if File.directory?("./generators")
                                "./generators"
                              elsif Dir.glob("./lib/**/generators").any?
                                Dir.glob("./lib/**/generators").first
                              else
                                "./"
                              end
      end

      def save_generator_to_destination_folder
        create_file File.join(@destination_folder, @results.filename), @results.code
      end

      def generate_command_if_requested
        return unless @generate_command

        say "Generating command..."

        generator_code = File.read(File.join(@destination_folder, @results.filename))
        command_results = SublayerCommandGenerator.new(generator_code: generator_code).generate
        @command_class_name = command_results.class_name
        @command_description = command_results.description
        @command_execute_body = command_results.execute_body
        @command_filename = command_results.filename

        commands_folder = File.join("lib", @project_name, "commands")

        destination_path = File.join(commands_folder, @command_filename)
        template("utilities/cli/command.rb.tt", destination_path)
      end

      private
      def is_cli_project?
        config_path = find_config_file
        return false unless config_path

        config = YAML.load_file(config_path)
        @project_name = config[:project_name]
        config[:project_template] == 'CLI'
      rescue StandardError => e
        say "Error reading project configuration: #{e.message}", :red
        false
      end

      def find_config_file
        possible_paths = [
          File.join(Dir.pwd, 'config', 'sublayer.yml'),
          File.join(Dir.pwd, 'lib', '*', 'config', 'sublayer.yml' )
        ]

        Dir.glob(possible_paths).first
      end

      def select_ai_model
        case @ai_provider
        when "OpenAI"
          ask("Which OpenAI model would you like to use?", default: "gpt-4o")
        when "Claude"
          ask("Which Anthropic model would you like to use?", default: "claude-3-5-sonnet-20240620")
        when "Gemini"
          ask("Which Google model would you like to use?", default: "gemini-1.5-flash-latest")
        end
      end
    end
  end
end
