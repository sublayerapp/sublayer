module Sublayer
  module Commands
    class NewProject < Thor::Group
      include Thor::Actions

      argument :project_name, type: :string, desc: "The name of your project"

      class_option :template, type: :string, desc: "Type of project (CLI, GithubAction, QuickScript)", aliases: :t
      class_option :provider, type: :string, desc: "AI provider (OpenAI, Claude, or Gemini)", aliases: :p
      class_option :model, type: :string, desc: "AI model name to use (e.g. gpt-4o, claude-3-haiku-20240307, gemini-1.5-flash-latest)", aliases: :m

      def sublayer_version
        Sublayer::VERSION
      end

      def self.source_root
        File.dirname(__FILE__)
      end

      def self.banner
        "sublayer new PROJECT_NAME"
      end

      def create_project
        @project_template = options[:template] || ask("Select a project template:", default: "CLI", limited_to: %w[CLI GithubAction QuickScript])

        case @project_template.downcase
        when 'cli'
          invoke Commands::CLIProject, [project_name], options
        when 'githubaction', 'github_action'
          invoke Commands::GithubActionProject, [project_name], options
        when 'quickscript', 'quick_script'
          invoke Commands::QuickScriptProject, [project_name], options
        else
          say "Unknown project template: #{@project_template}", :red
          exit 1
        end
      end
    end
  end
end
