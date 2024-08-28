require "spec_helper"

require_relative "../../../lib/sublayer/cli/commands/generators/sublayer_generator_generator"

RSpec.describe SublayerGeneratorGenerator do
  def generate(description)
    described_class.new(description: description).generate
  end

  context "Claude" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
      Sublayer.configuration.ai_model = "claude-3-haiku-20240307"
    end

    it "generates the Sublayer Generator code and filename" do
      VCR.use_cassette("claude/cli/generators/sublayer_generator_generator") do
        results = generate("a sublayer generator that takes in code and converts it to the users requested programming language")

        expect(results.filename).to be_a(String)
        expect(results.filename.length).to be > 0
        expect(results.code).to be_a(String)
        expect(results.code.length).to be > 0
      end
    end
  end

  context "OpenAI" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
      Sublayer.configuration.ai_model = "gpt-4o-mini"
    end

    it "generates the Sublayer Generator code and filename" do
      VCR.use_cassette("openai/cli/generators/sublayer_generator_generator") do
        results = generate("a sublayer generator that takes in code and converts it to the users requested programming language")

        expect(results.filename).to be_a(String)
        expect(results.filename.length).to be > 0
        expect(results.code).to be_a(String)
        expect(results.code.length).to be > 0
      end
    end

  end

  context "Gemini" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
      Sublayer.configuration.ai_model = "gemini-1.5-pro-latest"
    end

    it "generates the Sublayer Generator code and filename" do
      VCR.use_cassette("gemini/cli/generators/sublayer_generator_generator") do
        results = generate("a sublayer generator that takes in code and converts it to the users requested programming language")

        expect(results.filename).to be_a(String)
        expect(results.filename.length).to be > 0
        expect(results.code).to be_a(String)
        expect(results.code.length).to be > 0
      end
    end

  end
end
