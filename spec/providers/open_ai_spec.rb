require "spec_helper"

RSpec.describe Sublayer::Providers::OpenAI do
  before do
    Sublayer.configuration.ai_provider = described_class
    Sublayer.configuration.ai_model = "gpt-3.5-turbo"
  end

  describe "#call" do
    it "calls the OpenAI API" do
      VCR.use_cassette("openai/42") do
        output_adapter = Sublayer::Components::OutputAdapters.create(
          type: :single_string,
          name: "openai_response",
          description: "The response from OpenAI"
        )
        response = described_class.call(
          prompt: "What is the meaning of life? Give it to me as a number. Just a number. You can do it.",
          output_adapter: output_adapter
        )

        expect(response).to eq("42")
      end
    end
  end
end
