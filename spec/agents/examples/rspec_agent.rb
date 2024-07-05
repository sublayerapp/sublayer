class RSpecAgent < Sublayer::Agents::Base
  def initialize(implementation_file_path:, test_file_path:)
    @implementation_file_path = implementation_file_path
    @test_file_path = test_file_path
    @tests_passing = false
  end

  trigger_on_files_changed { [@implementation_file_path, @test_file_path] }

  goal_condition { @tests_passing == true }

  check_status do
    stdout, stderr, status = Sublayer::Actions::RunTestCommandAction.new(
      test_command: "rspec #{@test_file_path}"
    ).call

    @test_output = stdout
    @tests_passing = (status.exitstatus == 0)
  end

  step do
    modified_implementation = Sublayer::Generators::ModifiedImplementationToPassTestsGenerator.new(
      implementation_file_contents: File.read(@implementation_file_path),
      test_file_contents: File.read(@test_file_path),
      test_output: @test_output
    ).generate

    Sublayer::Actions::WriteFileAction.new(
      file_contents: modified_implementation,
      file_path: @implementation_file_path
    ).call
  end
end
