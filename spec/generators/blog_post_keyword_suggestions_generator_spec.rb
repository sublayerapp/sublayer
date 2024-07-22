require "spec_helper"

require "generators/examples/blog_post_keyword_suggestions_generator"

RSpec.describe BlogPostKeywordSuggestionGenerator do
  let(:topic) { "Artificial Intelligence in Healthcare" }
  let(:num_keywords) { 5 }

  subject { described_class.new(topic: topic, num_keywords: num_keywords) }

  context "claude" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
      Sublayer.configuration.ai_model = "claude-3-5-sonnet-20240620"
    end

    it "generates keyword suggestions for a blog post" do
      VCR.use_cassette("claude/generators/blog_post_keyword_suggestions_generator/ai_in_healthcare") do
        keywords = subject.generate
        expect(keywords).to be_an_instance_of(Array)
      end
    end
  end

  context "openai" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
      Sublayer.configuration.ai_model = "gpt-4o"
    end

    it "generates keyword suggestions for a blog post" do
      VCR.use_cassette("openai/generators/blog_post_keyword_suggestions_generator/ai_in_healthcare") do
        keywords = subject.generate
        expect(keywords).to be_an_instance_of(Array)
      end
    end
  end

  context "gemini" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
      Sublayer.configuration.ai_model = "gemini-pro"
    end

    it "generates keyword suggestions for a blog post" do
      VCR.use_cassette("gemini/generators/blog_post_keyword_suggestions_generator/ai_in_healthcare") do
        keywords = subject.generate
        expect(keywords).to be_an_instance_of(Array)
      end
    end
  end
end
