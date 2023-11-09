module Sublayer
  module Agents
    class JSONFixingAgent
      include Sublayer::Capabilities::LLMAssistance
      include Sublayer::Capabilities::HumanAssistance

      attr_reader :invalid_json, :results

      llm_result_format type: :single_string,
        name: "valid_json",
        description: "The valid JSON string"

      def initialize(invalid_json:)
        @invalid_json = invalid_json
      end

      def execute
        @results = llm_generate
      end

      def prompt
        <<-PROMPT
        You are an expert in JSON parsing.

        The given string is not a valid JSON: #{invalid_json}

        Please fix this and produce a valid JSON.
        PROMPT
      end
    end
  end
end
