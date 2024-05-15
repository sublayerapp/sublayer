class SentimentFromTextGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :string_selection_from_list,
    name: "sentiment_value",
    description: "A sentiment value from the list",
    options: -> { @sentiment_options }

  def initialize(text:, sentiment_options:)
    @text = text
    @sentiment_options = sentiment_options
  end

  def generate
    super
  end

  def prompt
    <<-PROMPT
        You are an expert at determining sentiment from text.

        You are tasked with analyzing the following text and determining its sentiment value.

        The text is:
        #{@text}
    PROMPT
  end
end
