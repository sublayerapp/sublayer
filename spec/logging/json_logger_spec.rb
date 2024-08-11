require "spec_helper"
require "tempfile"

RSpec.describe Sublayer::Logging::JsonLogger do
  let(:message) { "Test message" }
  let(:data) { { key: "value" } }
  let(:log_file) { Tempfile.new("sublayer_test_log") }
  let(:logger) { described_class.new(log_file.path) }

  after { log_file.unlink }

  it "logs messages in JSON format" do
    logger.log(:info, message, data)

    log_content = File.read(log_file.path)
    log_entry = JSON.parse(log_content)

    expect(log_entry["level"]).to eq("info")
    expect(log_entry["message"]).to eq(message)
    expect(log_entry["data"]).to eq(data.stringify_keys)
    expect(log_entry["timestamp"]).to be_a(String)
  end
end
