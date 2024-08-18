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
    input = "CLI\nOpenAI\ngpt-4o\nn\ny\n"

    output, status = Open3.capture2e(command, chdir: TMP_DIR, stdin_data: input)

    expect(status.success?).to be true
    expect(output).to include("Sublayer project '#{project_name}' created successfully!")

    expect(Dir.exist?(project_path)).to be true

    %w[bin lib spec log].each do |dir|
      expect(Dir.exist?(File.join(project_path, dir))).to be true
    end

    %w[].each do |file|
      expect(File.exist?(File.join(project_path, file))).to be true
    end

    Bundler.with_original_env do
      require_output, require_status = Open3.capture2e(
        "ruby", "-I", "#{project_path}/lib", "-r", "#{project_name}.rb", "-e", "puts 'Required successfully'"
      )

      puts "Require output: #{require_output}"
      puts "Require status: #{require_status}"
      expect(require_status.success?).to be true
      expect(require_output).to include("Required successfully")
    end

      command_output, command_status = Open3.capture2e(
        File.join(project_path, 'bin', project_name), "example",
        chdir: project_path
      )

      expect(command_status.success?).to be true
      expect(command_output).to include("Executing example command with args:")
  end
end
