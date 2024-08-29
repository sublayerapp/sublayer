require "spec_helper"

require_relative "../../../lib/sublayer/cli/commands/generators/sublayer_agent_generator"

RSpec.describe SublayerAgentGenerator do
  def generate(description, trigger, goal, check_status, step)
    described_class.new(
      description: description,
      trigger: trigger,
      goal: goal,
      check_status: check_status,
      step: step
    ).generate
  end

  context "Claude" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
      Sublayer.configuration.ai_model = "claude-3-haiku-20240307"
    end

    it "generates the sublayer agent code and filename" do
      VCR.use_cassette("claude/cli/generators/sublayer_agent_generator") do
        results = generate(
          "a sublayer agent that monitors a transcription folder and updates a notion crm with information from the latest transcriptions",
          "new files are added to a transcription folder",
          "all the transcription files in the folder have been processed",
          "see if there are any files in the transcription folder that havent been procesed",
          "take an unprocessed transcription file, generate a summary, and any followups, and update the notion crm with the information"
        )

        binding.pry
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

    it "generates the sublayer agent code and filename" do
      VCR.use_cassette("openai/cli/generators/sublayer_agent_generator") do
        results = generate(
          "a sublayer agent that monitors a transcription folder and updates a notion crm with information from the latest transcriptions",
          "new files are added to a transcription folder",
          "all the transcription files in the folder have been processed",
          "see if there are any files in the transcription folder that havent been procesed",
          "take an unprocessed transcription file, generate a summary, and any followups, and update the notion crm with the information"
        )

        binding.pry
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
      Sublayer.configuration.ai_model = "gemini-1.5-flash-latest"
    end

    it "generates the sublayer agent code and filename" do
      VCR.use_cassette("gemini/cli/generators/sublayer_agent_generator") do
        results = generate(
          "a sublayer agent that monitors a transcription folder and updates a notion crm with information from the latest transcriptions",
          "new files are added to a transcription folder",
          "all the transcription files in the folder have been processed",
          "see if there are any files in the transcription folder that havent been procesed",
          "take an unprocessed transcription file, generate a summary, and any followups, and update the notion crm with the information"
        )

        binding.pry
        expect(results.filename).to be_a(String)
        expect(results.filename.length).to be > 0
        expect(results.code).to be_a(String)
        expect(results.code.length).to be > 0
      end
    end
  end
end
