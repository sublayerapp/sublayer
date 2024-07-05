require "spec_helper"

RSpec.describe Sublayer::Triggers::Base do
  let(:test_trigger) { described_class.new }
  let(:test_agent) { double("Agent") }

  describe "#setup" do
    it "raises NotImplementedError" do
      expect { test_trigger.setup(test_agent) }.to raise_error(NotImplementedError)
    end
  end

  describe "#activate" do
    it "calls take_step on the agent" do
      expect(test_agent).to receive(:take_step)
      test_trigger.activate(test_agent)
    end
  end
end
