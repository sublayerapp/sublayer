require "spec_helper"

RSpec.describe Sublayer::Logging::DebugLogger do
  let(:message) { "Test message" }
  let(:data) { { key: "value" } }
  let(:logger) { described_class.new }

  it "outputs messages to stdout" do
    expect {
      logger.log(:info, message, data)
    }.to output(/\[.*\] INFO: #{message}/).to_stdout
  end

  it "pretty prints the data" do
    expected = if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4")
      /\{key: "value"\}/
    else
      /\{:key=>"value"\}/
    end

    expect {
      logger.log(:info, message, data)
    }.to output(expected).to_stdout
  end
end
