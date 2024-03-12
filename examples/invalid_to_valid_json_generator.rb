class InvalidToValidJsonGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :single_string,
    name: "valid_json",
    description: "The valid JSON string"

  def initialize(invalid_json:)
    @invalid_json = invalid_json
  end

  def generate
    super
  end

  def prompt
    <<-PROMPT
    You are an expert in JSON parsing.

    The given string is not a valid JSON: #{@invalid_json}

    Please fix this and produce a valid JSON.
    PROMPT
  end
end
