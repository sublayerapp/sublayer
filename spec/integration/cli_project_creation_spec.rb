require "spec_helper"
require "fileutils"
require "open3"
require "tmpdir"

TMP_DIR = ENV['RUNNER_TEMP'] || Dir.tmpdir

RSpec.describe "CLI Project Creation" do

  let(:project_name) { "test_project" }
  let(:project_path) { File.join(TMP_DIR, project_name) }

  before(:all) do
    FileUtils.mkdir_p(TMP_DIR)
  end

  after(:all) do
    FileUtils.rm_rf(TMP_DIR)
  end

  after(:each) do
    FileUtils.rm_rf(project_path)
  end

  it "creates a new project with all the expected files and structures" do
    command = "ruby -I lib #{File.dirname(__FILE__)}/../../bin/sublayer new #{project_name}"
    input = "CLI\nOpenAI\ngpt-4o\nn\n\n"

    output, status = Open3.capture2e(command, chdir: TMP_DIR, stdin_data: input)

    expect(status.success?).to be true
    expect(output).to include("Sublayer project '#{project_name}' created successfully!")

    expect(Dir.exist?(project_path)).to be true

    %w[bin lib spec log].each do |dir|
      expect(Dir.exist?(File.join(project_path, dir))).to be true
    end

    %w[
      bin/test_project
      lib/test_project.rb
      lib/test_project/version.rb
      lib/test_project/cli.rb
      lib/test_project/config.rb
      lib/test_project/commands/example_command.rb
      lib/test_project/commands/base_command.rb
      lib/test_project/actions/example_action.rb
      lib/test_project/agents/example_agent.rb
      lib/test_project/generators/example_generator.rb
      Gemfile
      test_project.gemspec
      README.md
      ].each do |file|
      expect(File.exist?(File.join(project_path, file))).to be true
    end
  end

  it "properly sets config values for ai_provider and ai_model" do
    command = "ruby -I lib #{File.dirname(__FILE__)}/../../bin/sublayer new #{project_name}"
    input = "CLI\nOpenAI\ngpt-4o\nn\n\n"

    output, status = Open3.capture2e(command, chdir: TMP_DIR, stdin_data: input)
    expect(status.success?).to be true

    # Check the config file was created
    config_file_path = File.join(project_path, "lib", project_name, "config", "sublayer.yml")
    expect(File.exist?(config_file_path)).to be true

    # Parse the YAML config and check values
    config = YAML.load_file(config_file_path)
    expect(config[:ai_provider]).to eq("OpenAI")
    expect(config[:ai_model]).to eq("gpt-4o")
    expect(config[:project_name]).to eq(project_name)
    expect(config[:project_template]).to eq("CLI")
  end
end
