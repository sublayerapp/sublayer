require "spec_helper"

RSpec.describe Sublayer::Providers::OpenAI do
  before do
    Sublayer.configuration.ai_provider = described_class
    Sublayer.configuration.ai_model = "gpt-4-turbo"
  end

  describe "#call" do
    it "calls the OpenAI API" do
      VCR.use_cassette("openai/42") do
        output_adapter = Sublayer::Components::OutputAdapters.create(
          type: :single_string,
          name: "the_answer",
          description: "The answer to the given question"
        )
        response = described_class.call(
          prompt: "What is the meaning of life, the universe, and everything?",
          output_adapter: output_adapter
        )

        expect(response).to eq("42")
      end
    end
  end
end
