module Sublayer
  module Commands
    class CLIProject < Thor::Group
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

        directory "../templates/cli", project_name
      end

      def generate_configuration
        say "Generating configuration", :green

        config = {
          project_name: @project_name,
          project_template: "CLI",
          ai_provider: @provider,
          ai_model: @model
        }

        create_file File.join(project_name, "lib", project_name, "config", "sublayer.yml"), YAML.dump(config)
      end

      def finalize_project
        say "Finalizing project", :green

        inside(project_name) do
          chmod("bin/#{project_name}", "+x")
          run("git init") if yes?("Initialize a git repository?")
          run("bundle install") if yes?("Install gems?")
        end
      end

      def print_next_steps
        say "\nSublayer project '#{project_name}' created successfully!", :green
        say "To get started, run:"
        say "  cd #{project_name}"
        say "  ./bin/#{project_name}"
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
