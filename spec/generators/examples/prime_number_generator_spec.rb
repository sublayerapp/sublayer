require "spec_helper"
require "sublayer/generators/examples/prime_number_generator"
require "prime"

RSpec.describe PrimeNumberGenerator do
  context "claude" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
      Sublayer.configuration.ai_model = "claude-3-haiku-20240307"
    end

    it 'generates a prime number' do
      VCR.use_cassette("claude/generators/prime_number_generator/prime_number") do
        output = described_class.new.generate
        p output
        expect(Prime.prime?(output)).to be_truthy
      end
    end
  end
  context "openai" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
      Sublayer.configuration.ai_model = "gpt-4-turbo"
    end

    it 'generates a prime number' do
      VCR.use_cassette("openai/generators/prime_number_generator/prime_number") do
        output = described_class.new.generate
        p output
        expect(Prime.prime?(output)).to be_truthy
      end
    end
  end

  context "Gemini" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
      Sublayer.configuration.ai_model = "gemini-pro"
    end

    it 'generates a prime number' do
      VCR.use_cassette("gemini/generators/prime_number_generator/prime_number") do
        output = described_class.new.generate
        p output
        expect(Prime.prime?(output)).to be_truthy
      end
    end
  end
end
