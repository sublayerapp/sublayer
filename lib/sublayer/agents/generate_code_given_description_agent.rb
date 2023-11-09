module Sublayer
  module Agents
    class GenerateCodeGivenDescriptionAgent
      include Sublayer::Capabilities::LLMAssistance
      include Sublayer::Capabilities::HumanAssistance

      attr_reader :description, :technologies, :results

      llm_result_format type: :single_string,
        name: "generated_code",
        description: "The generated code in the requested language"

      def initialize(description:, technologies:)
        @description = description
        @technologies = technologies
      end

      def execute
        @results = human_assistance_with(llm_generate)
      end

      def prompt
        <<-PROMPT
        You are an expert programmer in #{technologies.join(", ")}.

        You are tasked with writing code using the following technologies: #{technologies.join(", ")}.

        The description of the task is #{description}

        Take a deep breath and think step by step before you start coding.
        PROMPT
      end
    end
  end
end
