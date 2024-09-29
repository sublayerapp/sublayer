require "spec_helper"
require "fileutils"
require "open3"
require "tmpdir"

TMP_DIR = ENV['RUNNER_TEMP'] || Dir.tmpdir

RSpec.describe "Github Action Project Creation" do
  let(:project_name) { "test_action" }
  let(:project_path) { File.join(TMP_DIR, ".github", "workflows") }

  before(:all) do
    FileUtils.mkdir_p(TMP_DIR)
  end

  after(:all) do
    FileUtils.rm_rf(TMP_DIR)
  end

  after(:each) do
    FileUtils.rm_rf(project_path)
  end

  it "creates a new github action with all the expected files and structures" do
    command = "ruby -I lib #{File.dirname(__FILE__)}/../../bin/sublayer new #{project_name}"
    input = "GithubAction\nOpenAI\ngpt-4o\nn\n\n"

    output, status = Open3.capture2e(command, chdir: TMP_DIR, stdin_data: input)

    puts output
    expect(status.success?).to be true
    expect(output).to include("Sublayer Github Action Project '#{project_name}' created successfully!")
    expect(Dir.exist?(project_path)).to be true

    [
      project_name,
      "#{project_name}/actions",
      "#{project_name}/generators",
      "#{project_name}/agents"
    ].each do |dir|
      expect(Dir.exist?(File.join(project_path, dir))).to be true
    end

    [
      "#{project_name}.yml",
      "#{project_name}/#{project_name}.rb",
    ].each do |file|
      expect(File.exist?(File.join(project_path, file))).to be true
    end
  end
end
