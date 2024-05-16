require "spec_helper"

require "sublayer/generators/examples/route_selection_from_user_intent_generator"

RSpec.describe RouteSelectionFromUserIntentGenerator do
  def generate(text)
    described_class.new(user_intent: text).generate
  end

  def available_routes
    described_class.new(user_intent: "").available_routes
  end

  context "OpenAI" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
      Sublayer.configuration.ai_model = "gpt-4-turbo"
    end

    it "selects a route based on the user's intent" do
      VCR.use_cassette("openai/generators/route_selection_from_user_intent_generator/route") do
        user_intent = "I want to get all the users"
        route = generate(user_intent)
        expect(available_routes).to include(route)
      end
    end
  end

  context "Claude" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
      Sublayer.configuration.ai_model = "claude-3-haiku-20240307"
    end

    it "selects a route based on the user's intent" do
      VCR.use_cassette("claude/generators/route_selection_from_user_intent_generator/route") do
        user_intent = "I want to get all the users"
        route = generate(user_intent)
        expect(available_routes).to include(route)
      end
    end
  end

  context "Gemini" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
      Sublayer.configuration.ai_model = "gemini-pro"
    end

    it "selects a route based on the user's intent" do
      VCR.use_cassette("gemini/generators/route_selection_from_user_intent_generator/route") do
        user_intent = "I want to get all the users"
        route = generate(user_intent)
        expect(available_routes).to include(route)
      end
    end
  end
end
