require "spec_helper"

RSpec.describe Sublayer::Logging::NullLogger do
  let(:message) { "Test message" }
  let(:data) { { key: "value" } }
  let(:logger) { described_class.new }

  it "does not produce any output" do
    expect {
      logger.log(:info, message, data)
    }.not_to output.to_stdout
  end
end
