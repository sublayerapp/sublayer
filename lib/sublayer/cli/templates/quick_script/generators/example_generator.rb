# frozen_string_literal: true

class ExampleGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :single_string,
    name: "generated_text",
    description: "A simple generated text"

  def initialize(input:)
    @input = input
  end

  def generate
    super
  end

  def prompt
    <<-PROMPT
          Generate a simple story based on this input: #{@input}
    PROMPT
  end
end
