module Sublayer
  module Agents
    class GenerateDescriptionFromCodeAgent
      include Sublayer::Capabilities::LLMAssistance
      include Sublayer::Capabilities::HumanAssistance

      attr_reader :code_file_path, :code_description

      llm_result_format type: :single_string,
        name: "code_description",
        description: "A description of what the code in the file does"

      def initialize(code:)
        @code = code
      end

      def execute
        @code_description = llm_generate
      end

      def prompt
        <<-PROMPT
        You are an experienced software engineer. Below is a chunk of code:

        #{@code}

        Please read the code carefully and provide a high-level description of what this code does, including its purpose, functionalities, and any noteworthy details.
        PROMPT
      end
    end
  end
end
