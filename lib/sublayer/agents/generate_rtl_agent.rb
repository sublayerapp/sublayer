module Sublayer
  module Agents
    class ReactComponentTestGeneratorAgent
      include Sublayer::Capabilities::LLMAssistance
      include Sublayer::Capabilities::HumanAssistance

      attr_reader :component_description, :results

      llm_result_format type: :single_string,
        name: "generated_tests",
        description: "The comprehensive react testing library tests for the described component"

      def initialize(component_description:)
        @component_description = component_description
      end

      def execute
        @results = human_assistance_with(llm_generate)
      end

      def prompt
        <<-PROMPT
        You are an expert in React and the React Testing Library.

        You are tasked with writing comprehensive tests for a React component described as follows: #{@component_description}

        Please ensure that your tests cover the following:
        - Rendering of the component under normal conditions
        - Rendering of the component with props
        - Interactions with the component (if applicable)
        - Component lifecycle (if applicable)

        Consider all possible edge cases and remember to follow best practices for React Testing Library.
        PROMPT
      end
    end
  end
end
