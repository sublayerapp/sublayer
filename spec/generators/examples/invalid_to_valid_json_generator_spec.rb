require "spec_helper"

require "sublayer/generators/examples/invalid_to_valid_json_generator"

RSpec.describe InvalidToValidJsonGenerator do
  before do
    Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
    Sublayer.configuration.ai_model = "claude-3-haiku-20240307"
  end

  def generate(json)
    described_class.new(invalid_json: json).generate
  end

  it "does nothing to valid JSON" do
    VCR.use_cassette("claude/generators/invalid_to_valid_json_generator/valid_json") do
      json = %q({"valid": "json"})
      valid_json = generate(json)
      expect(valid_json).to eq json
    end
  end

  it "converts invalid JSON to valid JSON" do
    VCR.use_cassette("claude/generators/invalid_to_valid_json_generator/invalid_json") do
      invalid_json = %q({invalid: "json"})
      valid_json = generate(invalid_json)
      expect(valid_json).to eq %q({"invalid": "json"})
    end
  end
end
