class DocUpdateSuggestionGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :list_of_named_strings,
    name: "doc_update_suggestions",
    description: "List of doc update suggestions with usefulness scores",
    item_name: "suggestion",
    attributes: [
      { name: "suggestion", description: "description of the doc update suggestion and its reasoning" },
      { name: "file_changes", description: "description of the files and their respective changes" },
      { name: "usefulness_score", description: "A score from 1-10 indicating the usefulness of the suggestion" }, #unused
      { name: "title", description: "doc update suggestion title" } #unused
    ]

  def initialize(code_context:, doc_context:, context_ignore_list:, diff:)
    @code_context = code_context
    @doc_context = doc_context
    @context_ignore_list = context_ignore_list
    @diff = diff
  end

  def generate
    super
  end

  def prompt
    <<~PROMPT
      As an expert in documentation with a focus on concise and hierarchical organization. Consider the following:

      1. Newest changes:
      #{@diff}

      1. Documentation repository context:
      #{@doc_context}

      2. Code repository context:
      #{@code_context}

      3. Files excluded from updates (do not modify these files):
      #{@context_ignore_list}

      You are tasked with generating detailed and specific suggestions for updating a documentation repository based on the newest changes to the code repository.

      Generate documentation update suggestions, considering:
      1. The appropriate level in the documentation hierarchy for each change (high-level concepts vs. specific details)
      2. The impact of the changes on existing documentation (updates, additions, or removals)
      3. The importance of each change for user understanding and API use
      4. The need for examples or clarifications of new or modified functionality

      For each suggestion
      - Describe the suggestion and the reasoning behind it. Be specific.
      - Meticulously describe the files and the changes that should be made in them.
      - Indicate its usefulness, 10 being most useful and 1 being least, as a way of prioritizing which suggestion should be done first
      - A succinct title that encapsulates the spirit of the suggestion

      Guidelines:
      1. Do not suggest changes to any files excluded from updates
      2. Make the fewest number of suggestions possible to achieve the desired outcome
    PROMPT
  end
end