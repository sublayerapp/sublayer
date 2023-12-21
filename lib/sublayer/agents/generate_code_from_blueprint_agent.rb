module Sublayer
  module Agents
    class GenerateCodeFromBlueprintAgent
      include Sublayer::Capabilities::LLMAssistance
      include Sublayer::Capabilities::HumanAssistance

      attr_reader :description, :results

      llm_result_format type: :single_string,
        name: "generated_code",
        description: "The generated code for the description"

      def initialize(description:)
        @agent_description = description
      end

      def execute
        @results = llm_generate
      end

      def prompt
        <<-PROMPT
        You are an expert programmer and are great at looking at and understanding existing patterns and applying them to new situations.

        The blueprint we're working with is the structure of our index page to view our list of companies. You can find that blueprint here:
        #{File.read("/Users/swerner/Development/microapps/jobmatching/app/views/companies/index.html.erb")}

        You need to use the blueprint above and modify it so that it satisfied the following description:
        #{description}

        Take a deep breath and think step by step before you start coding.
        PROMPT
      end
    end
  end
end
