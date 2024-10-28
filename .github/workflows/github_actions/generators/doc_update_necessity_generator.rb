class DocUpdateNecessityGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :named_strings,
    name: "doc_update_score",
    description: "boolean and confidence score indicating if documentation changes are needed",
    attributes: [
      { name: "reasoning", description: "brief explanation for whether or not doc changes are needed" },
      { name: "confidence", description: "number from 0 to 1 indicating confidence in the decision" },
      { name: "needs_update", description: "boolean indicating if updates are needed" }
    ]

  def initialize(doc_context:, code_context:, diff:)
    @doc_context = doc_context
    @code_context = code_context
    @diff = diff
  end

  def generate
    super
  end

  def prompt
    <<~PROMPT
      Code diff:
      #{@diff}

      Code context:
      #{@code_context}

      Documentation context:
      #{@doc_context}

      Given the above code diff and context, determine if documentation updates are necessary.
      Consider the following factors:
      1. The significance of the changes
      2. Whether the changes affect public APIs or user-facing features
      3. If the changes introduce new concepts or modify existing ones
      4. Whether the current documentation accurately reflects the changes

      Based on this information, are documentation updates necessary?
    PROMPT
  end
end
