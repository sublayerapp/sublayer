class ImaginaryMovieReviewGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :list_of_named_strings,
    name: "review_summaries",
    description: "List of movie reviews",
    item_name: "review",
    attributes: [
      { name: "movie_title", description: "The title of the movie" },
      { name: "reviewer_name", description: "The name of the reviewer" },
      { name: "rating", description: "The rating given by the reviewer (out of 5 stars)" },
      { name: "brief_comment", description: "A brief summary of the movie" }
    ]

  def initialize(num_reviews:)
    @num_reviews = num_reviews
  end

  def generate
    super
  end

  def prompt
    <<-PROMPT
    You are a movie review summarizer.
    Please generate #{@num_reviews} movie review summaries with the following details for each:
    - movie_title: The title of a movie (real or fictional)
    - reviewer_name: A plausible name for a movie critic
    - rating: A rating out of 5 stars (format: X.X)
    - brief_comment: A concise summary of the review (1-2 sentences)

    Provide your response as a list of objects, each containing the above attributes.
    PROMPT
  end
end
