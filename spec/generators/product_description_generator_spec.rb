require "spec_helper"

require "generators/examples/product_description_generator"

RSpec.describe ProductDescriptionGenerator do
  def generate
    described_class.new(product_name: "Super Gadget", product_category: "Electronics").generate
  end

  context "OpenAI" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
      Sublayer.configuration.ai_model = "gpt-4o"
    end

    it "generates an with the correct keys" do
      VCR.use_cassette("openai/generators/product_description_generator/super_gadget") do
        result = generate
        expect(result).to respond_to(:short_description)
        expect(result).to respond_to(:long_description)
        expect(result).to respond_to(:key_features)
        expect(result).to respond_to(:target_audience)
      end
    end
  end

  context "Claude" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
      Sublayer.configuration.ai_model = "claude-3-haiku-20240307"
    end

    it "generates an with the correct keys" do
      VCR.use_cassette("claude/generators/product_description_generator/super_gadget") do
        result = generate
        expect(result).to respond_to(:short_description)
        expect(result).to respond_to(:long_description)
        expect(result).to respond_to(:key_features)
        expect(result).to respond_to(:target_audience)
      end
    end

  end

  xcontext "Gemini" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
      Sublayer.configuration.ai_model = "gemini-1.5-flash-latest"
    end

    it "generates an with the correct keys" do
      VCR.use_cassette("gemini/generators/product_description_generator/super_gadget") do
        result = generate
        expect(result).to respond_to(:short_description)
        expect(result).to respond_to(:long_description)
        expect(result).to respond_to(:key_features)
        expect(result).to respond_to(:target_audience)
      end
    end

  end
end
