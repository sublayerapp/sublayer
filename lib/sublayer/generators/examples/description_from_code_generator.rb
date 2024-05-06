class DescriptionFromCodeGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :single_string,
    name: "code_description",
    description: "A high-level description of code and what the code does"

  def initialize(code:)
    @code = code
  end

  def generate
    super
  end

  def prompt
    <<-PROMPT
        You are an experienced software engineer. Below is a chunk of code:

        #{@code}

        what does the code do?
    PROMPT
  end
end
