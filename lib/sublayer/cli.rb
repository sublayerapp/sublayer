require "tty-prompt"
require "tty-progressbar"
require "tty-command"
require "tty-file"
require "fileutils"
require "yaml"

module Sublayer
  class CLI
    PLACEHOLDERS = {
      "PROJECT_NAME" => { gsub: true, camelcase: false },
      "ProjectName" => { gsub: true, camelcase: true },
      "project_name" => { gsub: true, camelcase: false, underscore: true }
    }

    def self.start(args)
      new.run(args)
    end

    def run(args)
      command = args.shift

      case command
      when "new"
        create_new_project(args.first)
      when "help", nil
        display_help
      else
        puts "Unknown command: #{command}"
        display_help
      end
    end

    private

    def create_new_project(project_name)
      prompt = TTY::Prompt.new

      project_name ||= prompt.ask("What is the name of your project?")

      project_type = prompt.select("How would you like to interact with this agent?", ["CLI", "Web Service"])
      ai_provider = prompt.select("Which AI provider would you like to use?", ["OpenAI", "Claude", "Gemini"])

      ai_model = if ai_provider == "OpenAI"
                   prompt.select("Which OpenAI model would you like to use?", ["gpt-4o", "gpt-4o-mini", "gpt-4-turbo", "gpt-4", "gpt-3.5-turbo"])
                 elsif ai_provider == "Claude"
                   prompt.select("Which Anthropic model would you like to use?", ["claude-3-5-sonnet-20240620", "claude-3-opus-20240229", "claude-3-haiku-20240307"])
                 elsif ai_provider == "Gemini"
                   prompt.select("Which Gemini model would you like to use?", ["gemini-1.5-pro-latest", "gemini-1.5-flash-latest"])
                 end

    create_project(project_name, project_type, ai_provider, ai_model)
  end

  def create_project(project_name, project_type, ai_provider, ai_model)
    project_path = File.join(Dir.pwd, project_name)

    progress_bar = TTY::ProgressBar.new("Creating project [:bar] :percent", total: 8)

    progress_bar.advance(1, log: "Creating project directory")
    FileUtils.mkdir_p(project_path)

    progress_bar.advance(1, log: "Copying template files")
    copy_template_files(project_path, project_type)

    progress_bar.advance(1, log: "Copying shared files")
    copy_shared_files(project_path, project_type)

    progress_bar.advance(1, log: "Generating configuration")
    generate_config_file(project_path, project_name, project_type, ai_provider, ai_model)

    progress_bar.advance(1, log: "Creating README")
    create_readme(project_path, project_type, project_name)

    progress_bar.advance(1, log: "Replacing placeholders")
    replace_placeholders(project_path, project_name)

    progress_bar.advance(1, log: "Finalizing project")
    finalize_project(project_path, project_type)

    puts "\nSublayer project '#{project_name}' created successfully!"
  end

  def copy_template_files(project_path, project_type)
    template_dir = project_type == "CLI" ? "cli" : "web_service"
    source_path = File.join(File.dirname(__FILE__), "templates", template_dir)
    FileUtils.cp_r("#{source_path}/.", project_path)
  end

  def copy_shared_files(project_path, project_type)
    shared_path = File.join(File.dirname(__FILE__), "templates", "shared")
    destination_path = project_type == "CLI" ? File.join(project_path, "lib", File.basename(project_path)) : File.join(project_path, "app")
    FileUtils.cp_r("#{shared_path}/.", destination_path)
  end

  def generate_config_file(project_path, project_name, project_type, ai_provider, ai_model)
    config = {
      project_name: project_name,
      project_type: project_type,
      ai_provider: ai_provider,
      ai_model: ai_model
    }

    TTY::File.create_file(File.join(project_path, "sublayer.yml"), YAML.dump(config))
  end

  def create_readme(project_path, project_type, project_name)
    readme_template = File.read(File.join(File.dirname(__FILE__), "templates", "shared", "README.md"))
    readme_content = readme_template
      .gsub("ProjectName", project_name)
      .gsub("{{PROJECT_TYPE}}", project_type)
      .gsub("{{PROJECT_TYPE_SPECIFIC_INSTRUCTIONS}}", project_type_specific_instructions(project_type))

    TTY::File.create_file(File.join(project_path, "README.md"), readme_content)
  end

  def project_type_instructions(project_type)
    if project_type == "CLI"
      "Run your CLI application:\n   ```\n   ruby bin/#{File.basename(project_path)}\n   ```"
    else
      "Start your web server:\n   ```\n   ruby app.rb\n   ```\n   Then visit http://localhost:4567 in your browser."
    end
  end

  def replace_placeholders(project_path, project_name)
    Dir.glob("#{project_path}/**/*", File::FNM_DOTMATCH).each do |file_path|
      next if File.directory?(file_path)
      next if file_path.include?(".git/")

      content = File.read(file_path)
      PLACEHOLDERS.each do |placeholder, options|
        replacement = if options[:camelcase]
                        project_name.split("_").map(&:capitalize).join
                      elsif options[:underscore]
                        project_name.gsub("-", "_").downcase
                      else
                        project_name
                      end
        content.gsub!(placeholder, replacement) if options[:gsub]
      end

      File.write(file_path, content)

      if file_path.include?('PROJECT_NAME')
        new_path = file_path.gsub("PROJECT_NAME", project_name.gsub('-', '_').downcase)
        FileUtils.mv(file_path, new_path)
      end
    end
  end

  def finalize_project(project_path, project_type)
    cmd = TTY::Command.new(printer: :null)

    if TTY::Prompt.new.yes?("Initialize a git repository?")
      cmd.run("git init", chdir: project_path)
    end

    if TTY::Prompt.new.yes?("Install dependencies now?")
      cmd.run("bundle install", chdir: project_path)
    end

    puts "To get started, run:"
    puts "  cd #{File.basename(project_path)}"
    puts "  bundle exec #{project_type == 'CLI' ? File.basename(project_path) : 'ruby app.rb'}"
  end

  def display_help
    puts "Usage: sublayer [command] [arguments]"
    puts "Commands:"
    puts "  new PROJECT_NAME   Create a new Sublayer project"
    puts "  help               Display this help message"
  end
end
end
