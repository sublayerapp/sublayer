module Sublayer
  module Agents
    class GenerateCodeFromBlueprintAgent
      include Sublayer::Capabilities::LLMAssistance
      include Sublayer::Capabilities::HumanAssistance

      attr_reader :description, :results

      llm_result_format type: :single_string,
        name: "generated_code",
        description: "The generated code for the description"

      def initialize(blueprint_description:, blueprint_code:, description:)
        @blueprint_description = blueprint_description
        @blueprint_code = blueprint_code
        @description = description
      end

      def execute
        @results = llm_generate
      end

      def prompt
        <<-PROMPT
        You are an expert programmer and are great at looking at and understanding existing patterns and applying them to new situations.

        The blueprint we're working with is: #{@blueprint_description}.
        The code for that blueprint is:
        #{@blueprint_code}

        You need to use the blueprint above and modify it so that it satisfied the following description:
        #{@description}

        Take a deep breath and think step by step before you start coding.
        PROMPT
      end
    end
  end
end
