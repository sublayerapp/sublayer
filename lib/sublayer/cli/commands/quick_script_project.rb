module Sublayer
  module Commands
    class QuickScriptProject < Thor::Group
      include Thor::Actions

      argument :project_name

      class_option :provider, type: :string, desc: "AI provider (OpenAI, Claude, or Gemini)", aliases: :p
      class_option :model, type: :string, desc: "AI model name to use (e.g. gpt-4o, claude-3-haiku-20240307, gemini-1.5-flash-latest)", aliases: :m

      def self.source_root
        File.dirname(__FILE__)
      end

      def sublayer_version
        Sublayer::VERSION
      end

      def ask_for_project_details
        @ai_provider = options[:provider] || ask("Select an AI provider:", default: "OpenAI", limited_to: %w[OpenAI Claude Gemini])
        @ai_model = options[:model] || select_ai_model
      end

      def create_project_directory
        say "Creating project directory", :green

        empty_directory project_name
      end

      def copy_template_files
        say "Copying template files", :green

        directory "../templates/quick_script", project_name
      end

      def generate_configuration
        append_to_file File.join(project_name, "#{project_name}.rb") do
          <<~CONFIG
            Sublayer.configuration.ai_provider = Sublayer::Providers::#{@ai_provider}
            Sublayer.configuration.ai_model = "#{@ai_model}"
          CONFIG
        end
      end

      def finalize_project
        inside(project_name) do
          append_to_file "#{project_name}.rb" do
            <<~INSTRUCTIONS
              puts "Welcome to your quick Sublayer script!"
              puts "To get started, create some generators, actions, or agents in their respective directories and call them here"
              puts "For more information, visit https://docs.sublayer.com"
            INSTRUCTIONS
          end

          run("git init") if yes?("Initialize a git repository?")
        end
      end

      def print_next_steps
        say "\nSublayer project '#{project_name}' created successfully!", :green
        say "To get started, run:"
        say "  cd #{project_name}"
        say "  ruby #{project_name}.rb"
      end

      private
      def select_ai_model
        case @ai_provider
        when "OpenAI"
          ask("Which OpenAI model would you like to use?", default: "gpt-4o", limited_to: %w[gpt-4o gpt-4o-mini gpt-4-turbo gpt-3.5-turbo])
        when "Claude"
          ask("Which Anthropic model would you like to use?", default: "claude-3-5-sonnet-20240620", limited_to: %w[claude-3-5-sonnet-20240620 claude-3-opus-20240620 claude-3-haiku-20240307])
        when "Gemini"
          ask("Which Google model would you like to use?", default: "gemini-1.5-flash-latest", limited_to: %w[gemini-1.5-flash-latest gemini-1.5-pro-latest])
        end
      end
    end
  end
end
