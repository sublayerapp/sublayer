require "spec_helper"

require "generators/examples/task_steps_generator"

RSpec.describe TaskStepsGenerator do
  subject { described_class.new(task: "Set up a new Ruby on Rails project") }

  context "OpenAI" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
      Sublayer.configuration.ai_model = "gpt-4o"
    end

    it "generates a list of steps with descriptions and commands" do
      VCR.use_cassette("openai/generators/task_steps_generator/ruby_on_rails_project") do
        steps = subject.generate

        expect(steps).to be_an(Array)
        expect(steps.size).to be > 0
        expect(steps.first).to respond_to(:description)
        expect(steps.first).to respond_to(:command)
        expect(steps.first.description).to be_a(String)
        expect(steps.first.command).to be_a(String)
      end
    end
  end

  context "Claude" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
      Sublayer.configuration.ai_model = "claude-3-haiku-20240307"
    end

    it "generates a list of steps with descriptions and commands" do
      VCR.use_cassette("claude/generators/task_steps_generator/ruby_on_rails_project") do
        steps = subject.generate

        expect(steps).to be_an(Array)
        expect(steps.size).to be > 0
        expect(steps.first).to respond_to(:description)
        expect(steps.first).to respond_to(:command)
        expect(steps.first.description).to be_a(String)
        expect(steps.first.command).to be_a(String)
      end
    end
  end

  context "Gemini" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
      Sublayer.configuration.ai_model = "gemini-1.5-pro-latest"
    end

    it "generates a list of steps with descriptions and commands" do
      VCR.use_cassette("gemini/generators/task_steps_generator/ruby_on_rails_project") do
        steps = subject.generate

        expect(steps).to be_an(Array)
        expect(steps.size).to be > 0
        expect(steps.first).to respond_to(:description)
        expect(steps.first).to respond_to(:command)
        expect(steps.first.description).to be_a(String)
        expect(steps.first.command).to be_a(String)
      end
    end
  end
end
