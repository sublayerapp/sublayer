class BlogPostKeywordSuggestionGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :list_of_strings,
    name: "suggestions",
    description: "List of keyword suggestions"

  def initialize(topic:, num_keywords: 5)
    @topic = topic
  end

  def generate
    super
  end

  def prompt
    <<-PROMPT
    You are an SEO expect tasked with suggesting keywords for a blog post.

    The blog post topic is: #{@topic}

    Please suggest relevant #{@num_keywords} keywords or key phrases for this post's topic.
    Each keyword or phrase should be concise and directly related to the topic.

    Provide your suggestions as a list of strings.
    PROMPT
  end
end
