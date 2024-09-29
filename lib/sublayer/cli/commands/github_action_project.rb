module Sublayer
  module Commands
    class GithubActionProject < Thor::Group
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

        empty_directory ".github/workflows"
      end

      def copy_template_files
        say "Copying template files", :green

        directory "../templates/github_action", ".github/workflows"
      end

      def generate_configuration

      end

      def finalize_project

      end

      def print_next_steps
        say "\nSublayer Github Action Project '#{project_name}' created successfully!", :green
        say "To get started: "
        say "Create some Sublayer Actions and Sublayer generators within '.github/workflows/#{project_name}/{actions/,generators/}'"
        say "And edit the file at '.github/workflows/#{project_name}.yml' to set up what you want the action triggered by"
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
