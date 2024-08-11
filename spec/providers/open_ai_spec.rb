require "spec_helper"

RSpec.describe Sublayer::Providers::OpenAI do
  before do
    Sublayer.configuration.ai_provider = described_class
    Sublayer.configuration.ai_model = "gpt-4o"
  end

  let(:basic_output_adapter) {
    Sublayer::Components::OutputAdapters.create(
      type: :single_string,
      name: "the_answer",
      description: "The answer to the given question"
    ).extend(Sublayer::Components::OutputAdapters::Formattable)
  }

  describe "#call" do
    it "calls the OpenAI API" do
      VCR.use_cassette("openai/42") do
        response = described_class.call(
          prompt: "What is the meaning of life, the universe, and everything?",
          output_adapter: basic_output_adapter
        )

        expect(response).to eq("42")
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
        expect(mock_logger).to receive(:log).with(:info, "OpenAI API request", hash_including(:model, :prompt))
        expect(mock_logger).to receive(:log).with(:info, "OpenAI API response", instance_of(Hash))

        VCR.use_cassette("openai/42") do
          described_class.call(
            prompt: "What is the meaning of life, the universe, and everything?",
            output_adapter: basic_output_adapter
          )
        end
      end
    end

    context "when there is an empty function call" do
      it "raises an empty response exception" do
        VCR.use_cassette("openai/empty_response") do
          expect {
            described_class.call(
              prompt: "Write a description of a historical event that happened in the past on this day #{Date.today}",
              output_adapter: Sublayer::Components::OutputAdapters.create(
                type: :single_string,
                name: "historical_event_description",
                description: "the historical event on this day in the past"
              ).extend(Sublayer::Components::OutputAdapters::Formattable)
            )
          }.to raise_error(/Empty response/)
        end
      end
    end

    context "When there is no function call" do
      it "raises a no function called exception" do
        VCR.use_cassette("openai/no_function") do
          expect {
            described_class.call(
              prompt: "Write a description of a historical event that happened in the past on this day #{Date.today}",
              output_adapter: Sublayer::Components::OutputAdapters.create(
                type: :single_string,
                name: "historical_event_description",
                description: "the historical event on this day in the past"
              ).extend(Sublayer::Components::OutputAdapters::Formattable)
            )
          }.to raise_error(/No function called/)
        end
      end
    end
  end
end
