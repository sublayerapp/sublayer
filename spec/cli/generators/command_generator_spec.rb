require "spec_helper"

require_relative "../../../lib/sublayer/cli/commands/generators/sublayer_command_generator"

RSpec.describe SublayerCommandGenerator do
  def generate
    described_class.new(generator_code: File.read("spec/generators/examples/task_steps_generator.rb")).generate
  end

  context "OpenAI" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
      Sublayer.configuration.ai_model = "gpt-4o-mini"
    end

    it "generates the Sublayer Command code and filename" do
      VCR.use_cassette("openai/cli/generators/sublayer_command_generator") do
        results = generate

        expect(results.filename).to be_a(String)
        expect(results.filename.length).to be > 0
        expect(results.class_name).to be_a(String)
        expect(results.class_name.length).to be > 0
        expect(results.description).to be_a(String)
        expect(results.description.length).to be > 0
        expect(results.execute_body).to be_a(String)
        expect(results.execute_body.length).to be > 0
      end
    end
  end

  context "Gemini" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
      Sublayer.configuration.ai_model = "gemini-1.5-flash"
    end

    it "generates the Sublayer Command code and filename" do
      VCR.use_cassette("gemini/cli/generators/sublayer_command_generator") do
        results = generate

        expect(results.filename).to be_a(String)
        expect(results.filename.length).to be > 0
        expect(results.class_name).to be_a(String)
        expect(results.class_name.length).to be > 0
        expect(results.description).to be_a(String)
        expect(results.description.length).to be > 0
        expect(results.execute_body).to be_a(String)
        expect(results.execute_body.length).to be > 0
      end
    end
  end

  context "Claude" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
      Sublayer.configuration.ai_model = "claude-3-haiku-20240307"
    end

    it "generates the Sublayer Command code and filename" do
      VCR.use_cassette("claude/cli/generators/sublayer_command_generator") do
        results = generate

        expect(results.filename).to be_a(String)
        expect(results.filename.length).to be > 0
        expect(results.class_name).to be_a(String)
        expect(results.class_name.length).to be > 0
        expect(results.description).to be_a(String)
        expect(results.description.length).to be > 0
        expect(results.execute_body).to be_a(String)
        expect(results.execute_body.length).to be > 0
      end
    end
  end
end