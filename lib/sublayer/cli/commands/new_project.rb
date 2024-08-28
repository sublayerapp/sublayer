module Sublayer
  module Commands
    class NewProject < Thor::Group
      include Thor::Actions

      argument :project_name, type: :string, desc: "The name of your project"

      class_option :template, type: :string, desc: "Type of project (CLI or QuickScript)", aliases: :t
      class_option :provider, type: :string, desc: "AI provider (OpenAI, Claude, or Gemini)", aliases: :p
      class_option :model, type: :string, desc: "AI model name to use (e.g. gpt-4o, claude-3-haiku-20240307, gemini-1.5-flash-latest)", aliases: :m

      def sublayer_version
        Sublayer::VERSION
      end

      def self.source_root
        File.dirname(__FILE__)
      end

      def ask_for_project_details
        puts options[:template]
        @project_template = options[:template] || ask("Select a project template:", default: "CLI", limited_to: %w[CLI QuickScript])
        @ai_provider = options[:provider] || ask("Select an AI provider:", default: "OpenAI", limited_to: %w[OpenAI Claude Gemini])
        @ai_model = options[:model] || select_ai_model
      end

      def create_project_directory
        say "Creating project directory", :green
        empty_directory project_name
      end

      def copy_template_files
        say "Copying template files", :green
        template_dir = @project_template == "CLI" ? "cli" : "quick_script"
        directory "../templates/#{template_dir}", project_name
        empty_directory File.join(project_name, "log") if @project_template =="CLI"
      end

      def generate_config_file
        say "Generating configuration", :green

        config = {
          project_name: project_name,
          project_template: @project_template,
          ai_provider: @ai_provider,
          ai_model: @ai_model
        }

        if @project_template == "CLI"
          create_file File.join(project_name, "lib", project_name, "config", "sublayer.yml"), YAML.dump(config)
        else
          append_to_file File.join(project_name, "#{project_name}.rb") do
            <<~CONFIG
            Sublayer.configuration.ai_provider = Sublayer::Providers::#{config[:ai_provider]}
            Sublayer.configuration.ai_model = "#{config[:ai_model]}"
            CONFIG
          end
        end
      end

      def finalize_project
        say "Finalizing project", :green
        inside(project_name) do
          run("git init") if yes?("Initialize a git repository?")
          run("bundle install") if yes?("Install gems?")
        end
      end

      def print_next_steps
        say "\nSublayer project '#{project_name}' created successfully!", :green
        say "To get started, run:"
        say "  cd #{project_name}"
        if @project_template == "CLI"
          say "  ./bin/#{project_name}"
        else
          say "  ruby #{project_name}.rb"
        end
      end

      private

      def select_ai_model
        case @ai_provider
        when "OpenAI"
          ask("Which OpenAI model would you like to use?", default: "gpt-4o", limited_to: %w[gpt-4o gpt-4o-mini gpt-4-turbo gpt-3.5-turbo])
        when "Claude"
          ask("Which Anthropic model would you like to use?", default: "claude-3-5-sonnet-20240620", limited_to: %[claude-3-5-sonnet-20240620 claude-3-opus-20240620 claude-3-haiku-20240307])
        when "Gemini"
          ask("Which Google model would you like to use?", default: "gemini-1.5-flash-latest", limited_to: %[gemini-1.5-flash-latest gemini-1.5-pro-latest])
        end
      end

      def rename_project_name_directory
        old_path = File.join(project_name, "lib", "PROJECT_NAME")
        new_path = File.join(project_name, "lib", project_name.gsub("-", "_").downcase)

        if File.directory?(old_path)
          say "Renaming project directory", :green
          FileUtils.mv(old_path, new_path)
        end
      end
    end
  end
end
