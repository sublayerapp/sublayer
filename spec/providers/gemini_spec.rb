require "spec_helper"

RSpec.describe Sublayer::Providers::Gemini do
  let(:basic_output_adapter) {
    Sublayer::Components::OutputAdapters.create(
      type: :single_string,
      name: "the_answer",
      description: "The answer to the given question"
    ).extend(Sublayer::Components::OutputAdapters::Formattable)
  }

  before do
    Sublayer.configuration.ai_provider = described_class
    Sublayer.configuration.ai_model = "gemini-1.5-flash-latest"
  end

  xdescribe "#call" do
    it "calls the Gemini API" do
      VCR.use_cassette("gemini/42") do
        response = described_class.call(
          prompt: "What is the meaning of life, the universe, and everything?",
          output_adapter: basic_output_adapter
        )

        expect(response).to be_a(String)
        expect(response.length).to be > 0
      end

      context "logging" do
        let(:mock_logger) { instance_double(Sublayer::Logging::Base) }

        before do
          Sublayer.configuration.logger = mock_logger
        end

        after do
          Sublayer.configuration.logger = Sublayer::Logging::NullLogger.new
        end

        it "logs the request and response" do
          expect(mock_logger).to receive(:log).with(:info, "Gemini API request", hash_including(:model, :prompt))
          expect(mock_logger).to receive(:log).with(:info, "Gemini API response", instance_of(Hash))

          VCR.use_cassette("gemini/42") do
            described_class.call(
              prompt: "What is the meaning of life, the universe, and everything?",
              output_adapter: basic_output_adapter
            )
          end
        end
      end
    end
  end
end
