require "spec_helper"

require "agents/examples/rspec_agent"

RSpec.describe RSpecAgent do
  let!(:run_command_action) { class_double("Sublayer::Actions::RunTestCommandAction").as_stubbed_const }
  let!(:modified_implementation_generator) { class_double("Sublayer::Generators::ModifiedImplementationToPassTestsGenerator").as_stubbed_const }
  let!(:write_file_action) { class_double("Sublayer::Actions::WriteFileAction").as_stubbed_const }
  let(:agent) { described_class.new(implementation_file_path: "lib/my_class.rb", test_file_path: "spec/my_class_spec.rb") }

  describe "initialize" do
    before do
      allow(run_command_action).to receive(:new).and_return(double(call: ["", "", double(exitstatus: 0)]))
      allow(modified_implementation_generator).to receive(:new).and_return(double(generate: ""))
      allow(write_file_action).to receive(:new).and_return(double(call: nil))
    end

    it "sets the implementation file path" do
      expect(agent.instance_variable_get(:@implementation_file_path)).to eq("lib/my_class.rb")
    end

    it "sets the test file path" do
      expect(agent.instance_variable_get(:@test_file_path)).to eq("spec/my_class_spec.rb")
    end

    it "sets tests passing to false" do
      expect(agent.instance_variable_get(:@tests_passing)).to be false
    end
  end

  describe "trigger_on_files_changed" do
    it "correctly sets up the triggers" do
      expect(Listen).to receive(:to).with(File.dirname(File.expand_path("lib/my_class.rb")), File.dirname(File.expand_path("spec/my_class_spec.rb"))).and_return(double(start: true))

      allow(run_command_action).to receive(:new).and_return(double(call: ["", "", double(exitstatus: 0)]))
      allow(modified_implementation_generator).to receive(:new).and_return(double(generate: ""))
      allow(write_file_action).to receive(:new).and_return(double(call: nil))
      expect(agent.class.triggers.size).to eq(1)
      allow(agent).to receive(:sleep)

      agent.run
    end
  end

  describe "checking status" do
    context "when the tests are passing" do
      it "makes it so the goal condition is met" do
        expect(Listen).to receive(:to).with(File.dirname(File.expand_path("lib/my_class.rb")), File.dirname(File.expand_path("spec/my_class_spec.rb"))).and_return(double(start: true))

        allow(run_command_action).to receive(:new).and_return(double(call: ["", "", double(exitstatus: 0)]))
        allow(modified_implementation_generator).to receive(:new).and_return(double(generate: ""))
        allow(write_file_action).to receive(:new).and_return(double(call: nil))
        allow(agent).to receive(:sleep)

        agent.run

        expect(agent.instance_eval(&agent.class.goal_condition_block)).to be true
      end

    end

    context "when the tests aren't passing" do
      it "makes it so the goal condition isn't met" do
        expect(Listen).to receive(:to).with(File.dirname(File.expand_path("lib/my_class.rb")), File.dirname(File.expand_path("spec/my_class_spec.rb"))).and_return(double(start: true))
        expect(File).to receive(:read).with("lib/my_class.rb").and_return("class MyClass\nend")
        expect(File).to receive(:read).with("spec/my_class_spec.rb").and_return("require 'my_class'\n\ndescribe MyClass do\n  it 'does something' do\n    expect(MyClass.new).to be_truthy\n  end\nend")

        allow(run_command_action).to receive(:new).and_return(double(call: ["", "", double(exitstatus: 1)]))
        allow(modified_implementation_generator).to receive(:new).and_return(double(generate: ""))
        allow(write_file_action).to receive(:new).and_return(double(call: nil))
        allow(agent).to receive(:sleep)

        agent.run

        expect(agent.instance_eval(&agent.class.goal_condition_block)).to be false
      end
    end
  end
end
