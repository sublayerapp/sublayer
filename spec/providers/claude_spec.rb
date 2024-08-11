require "spec_helper"

RSpec.describe Sublayer::Providers::Claude do
  let(:basic_output_adapter) {
    Sublayer::Components::OutputAdapters.create(
      type: :single_string,
      name: "the_answer",
      description: "The answer to the given question"
    ).extend(Sublayer::Components::OutputAdapters::Formattable)
  }

  before do
    Sublayer.configuration.ai_provider = described_class
    Sublayer.configuration.ai_model = "claude-3-haiku-20240307"
  end

  describe "#call" do
    it "calls the Claude API" do
      VCR.use_cassette("claude/42") do
        response = described_class.call(
          prompt: "What is the meaning of life, the universe, and everything?",
          output_adapter: basic_output_adapter
        )

        expect(response).to be_a(String)
        expect(response.length).to be > 0
      end
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
        expect(mock_logger).to receive(:log).with(:info, "Claude API request", hash_including(:model, :prompt))
        expect(mock_logger).to receive(:log).with(:info, "Claude API response", instance_of(Hash))

        VCR.use_cassette("claude/42") do
          described_class.call(
            prompt: "What is the meaning of life, the universe, and everything?",
            output_adapter: basic_output_adapter
          )
        end
      end

    end

    context "when the API returns a non-200 status code" do
      it "raises an error" do
        expect(HTTParty).to receive(:post).and_return(double(code: 500, body: "Internal Server Error"))

        expect {
          described_class.call(
            prompt: "What is the meaning of life, the universe, and everything?",
            output_adapter: basic_output_adapter
          )
        }.to raise_error("Error generating with Claude, error: Internal Server Error")
      end
    end

    context "when the API doesn't call a function" do
      it "raises a no function called exception" do
        VCR.use_cassette("claude/no_function") do
          expect {
            described_class.call(
              prompt: "What is the meaning of life, the universe, and everything?",
              output_adapter: basic_output_adapter
            )
          }.to raise_error(/No function called/)
        end
      end
    end
  end
end
