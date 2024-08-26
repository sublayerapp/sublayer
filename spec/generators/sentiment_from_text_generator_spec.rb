require "spec_helper"

require "generators/examples/sentiment_from_text_generator"

RSpec.describe SentimentFromTextGenerator do
  def generate(text)
    described_class.new(text: text, sentiment_options: %w[positive negative neutral]).generate
  end

  context "OpenAI" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
      Sublayer.configuration.ai_model = "gpt-4-turbo"
    end

    it "generates a sentiment value from the text" do
      VCR.use_cassette("openai/generators/sentiment_from_text_generator/positive") do
        text = "Matz is nice so we are nice"
        sentiment_value = generate(text)
        expect(["positive", "negative", "neutral"]).to include(sentiment_value)
      end
    end
  end

  context "Claude" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
      Sublayer.configuration.ai_model = "claude-3-haiku-20240307"
    end

    it "generates a sentiment value from the text" do
      VCR.use_cassette("claude/generators/sentiment_from_text_generator/positive") do
        text = "Matz is nice so we are nice"
        sentiment_value = generate(text)
        expect(["positive", "negative", "neutral"]).to include(sentiment_value)
      end
    end
  end

  context "Gemini" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
      Sublayer.configuration.ai_model = "gemini-1.5-flash-latest"
    end

    it "generates a sentiment value from the text" do
      VCR.use_cassette("gemini/generators/sentiment_from_text_generator/positive") do
        text = "Matz is nice so we are nice"
        sentiment_value = generate(text)
        expect(["positive", "negative", "neutral"]).to include(sentiment_value)
      end
    end
  end
end
