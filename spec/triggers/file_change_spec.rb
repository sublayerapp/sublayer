require "spec_helper"

RSpec.describe Sublayer::Triggers::FileChange do
  let(:test_agent) { double("Agent") }
  let(:block) { -> { ["file1.txt", "file2.txt"] } }
  let(:trigger) { described_class.new(&block) }

  describe "#initialize" do
    it "stores the provided block" do
      expect(trigger.instance_variable_get(:@block)).to eq(block)
    end
  end

  describe "#setup" do
    let(:listen_mock) { double("Listen") }
    let(:listener_mock) { double("Listener") }

    before do
      allow(Listen).to receive(:to).and_return(listen_mock)
      allow(listen_mock).to receive(:start).and_return(listener_mock)
      allow(test_agent).to receive(:instance_eval).and_return(["file1.txt", "file2.txt"])
      allow(File).to receive(:dirname).and_return("/test/path")
      allow(File).to receive(:expand_path) { |file| "/test/path/#{file}" }
    end

    it "sets up a listener for the specified files" do
      expect(Listen).to receive(:to).with("/test/path").and_return(listen_mock)
      expect(listen_mock).to receive(:start)

      trigger.setup(test_agent)
    end
  end
end
