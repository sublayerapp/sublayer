require "spec_helper"

RSpec.describe Sublayer::Agents::Base do
  let(:test_agent_class) do
    Class.new(described_class) do
      trigger_on_files_changed { ["test_file.txt"] }
      goal_condition { @goal_reached }
      check_status { @status_checked = true }
      step { @step_taken = true }

      attr_accessor :goal_reached, :status_checked, :step_taken
    end
  end

  let(:agent) { test_agent_class.new }

  describe ".trigger" do
    it "adds triggers to the agent class" do
      expect(test_agent_class.triggers.size).to eq(1)
    end

    it "accepts custom trigger instances" do
      custom_trigger = Sublayer::Triggers::Base.new

      test_agent_class.trigger(custom_trigger)
      expect(test_agent_class.triggers.last).to eq(custom_trigger)
    end
  end

  describe "#run" do
    before do
      allow(Listen).to receive(:to).and_return(double(start: true))
      allow(agent).to receive(:sleep)
    end

    it "sets up triggers and takes a step" do
      expect(agent).to receive(:setup_triggers)
      expect(agent).to receive(:take_step)
      expect(agent).to receive(:sleep)

      agent.run
    end
  end

  describe "#take_step" do
    context "when goal is not reached" do
      before { agent.goal_reached = false }

      it "checks status and takes a step" do
        agent.send(:take_step)
        expect(agent.status_checked).to be true
        expect(agent.step_taken).to be true
      end
    end

    context "when the goal is reached" do
      before { agent.goal_reached = true }

      it "checks status but does not take a step" do
        agent.send(:take_step)
        expect(agent.status_checked).to be true
        expect(agent.step_taken).to be_nil
      end
    end
  end
end
