require "spec_helper"

require "generators/examples/imaginary_movie_review_generator"

RSpec.describe ImaginaryMovieReviewGenerator do
  subject { described_class.new(num_reviews: 3) }

  context "OpenAI" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
      Sublayer.configuration.ai_model = "gpt-4o"
    end

    it "generates a list of imaginary movie reviews" do
      VCR.use_cassette("openai/generators/imaginary_movie_review_generator/3_reviews") do
        reviews = subject.generate

        expect(reviews).to be_an(Array)
        expect(reviews.size).to eq(3)
        expect(reviews.first).to respond_to(:movie_title)
        expect(reviews.first).to respond_to(:reviewer_name)
        expect(reviews.first).to respond_to(:rating)
        expect(reviews.first).to respond_to(:brief_comment)

        expect(reviews.first.movie_title).to be_a(String)
        expect(reviews.first.reviewer_name).to be_a(String)
        expect(reviews.first.rating).to be_a(String)
        expect(reviews.first.brief_comment).to be_a(String)
      end
    end
  end

  context "OpenAI" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
      Sublayer.configuration.ai_model = "claude-3-haiku-20240307"
    end

    it "generates a list of imaginary movie reviews" do
      VCR.use_cassette("claude/generators/imaginary_movie_review_generator/3_reviews") do
        reviews = subject.generate

        expect(reviews).to be_an(Array)
        expect(reviews.size).to eq(3)
        expect(reviews.first).to respond_to(:movie_title)
        expect(reviews.first).to respond_to(:reviewer_name)
        expect(reviews.first).to respond_to(:rating)
        expect(reviews.first).to respond_to(:brief_comment)

        expect(reviews.first.movie_title).to be_a(String)
        expect(reviews.first.reviewer_name).to be_a(String)
        expect(reviews.first.rating).to be_a(String)
        expect(reviews.first.brief_comment).to be_a(String)
      end
    end
  end

  context "Gemini" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
      Sublayer.configuration.ai_model = "gemini-1.5-pro-latest"
    end

    it "generates a list of imaginary movie reviews" do
      VCR.use_cassette("gemini/generators/imaginary_movie_review_generator/3_reviews") do
        reviews = subject.generate

        expect(reviews).to be_an(Array)
        expect(reviews.size).to eq(3)
        expect(reviews.first).to respond_to(:movie_title)
        expect(reviews.first).to respond_to(:reviewer_name)
        expect(reviews.first).to respond_to(:rating)
        expect(reviews.first).to respond_to(:brief_comment)

        expect(reviews.first.movie_title).to be_a(String)
        expect(reviews.first.reviewer_name).to be_a(String)
        expect(reviews.first.rating).to be_a(String)
        expect(reviews.first.brief_comment).to be_a(String)
      end
    end
  end
end
