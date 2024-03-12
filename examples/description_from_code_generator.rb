class DescriptionFromCodeGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :single_string,
    name: "code_description",
    description: "A description of what the code in the file does"

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

        Please read the code carefully and provide a high-level description of what this code does, including its purpose, functionalities, and any noteworthy details.
    PROMPT
  end
end
