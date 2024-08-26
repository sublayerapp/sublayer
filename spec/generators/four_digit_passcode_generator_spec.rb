require "spec_helper"

require "generators/examples/four_digit_passcode_generator"

RSpec.describe FourDigitPasscodeGenerator do
  def generate
    described_class.new.generate
  end

  context "OpenAI" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
      Sublayer.configuration.ai_model = "gpt-4o-2024-08-06"
    end

    it "generates an with the correct keys" do
      VCR.use_cassette("openai/generators/four_digit_passcode_generator/find_number") do
        result = generate
        expect(result).to be_an_instance_of(Integer)
      end
    end
  end

  context "Claude" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
      Sublayer.configuration.ai_model = "claude-3-haiku-20240307"
    end

    it "generates an with the correct keys" do
      VCR.use_cassette("claude/generators/four_digit_passcode_generator/find_number") do
        result = generate
        expect(result).to be_an_instance_of(Integer)
      end
    end
  end

  context "Gemini" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
      Sublayer.configuration.ai_model = "gemini-1.5-flash-latest"
    end

    it "generates an with the correct keys" do
      VCR.use_cassette("gemini/generators/four_digit_passcode_generator/find_number") do
        result = generate
        expect(result).to be_an_instance_of(Integer)
      end
    end
  end
end
