require "spec_helper"
require "fileutils"
require "open3"
require "tmpdir"

TMP_DIR = ENV['RUNNER_TEMP'] || Dir.tmpdir

RSpec.describe "Quick Script Project Creation" do
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
    command = "ruby -I lib #{File.dirname(__FILE__)}/../../bin/sublayer new #{project_name} --template quick_script"
    input = "OpenAI\ngpt-4o\nn\n\n"

    output, status = Open3.capture2e(command, chdir: TMP_DIR, stdin_data: input)

    expect(status.success?).to be true
    expect(output).to include("Sublayer project '#{project_name}' created successfully!")

    expect(Dir.exist?(project_path)).to be true

    %w[
      test_project.rb
      agents/example_agent.rb
      generators/example_generator.rb
      actions/example_action.rb
      README.md
    ].each do |file|
      expect(File.exist?(File.join(project_path, file))).to be true
    end
  end
end
