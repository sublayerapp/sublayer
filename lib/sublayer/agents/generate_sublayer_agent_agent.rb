module Sublayer
  module Agents
    class GenerateSublayerAgentAgent
      include Sublayer::Capabilities::LLMAssistance
      include Sublayer::Capabilities::HumanAssistance

      attr_reader :agent_description, :results

      llm_result_format type: :single_string,
        name: "generated_sublayer_agent",
        description: "The ruby code for the sublayer agent"

      def initialize(agent_description:)
        @agent_description = agent_description
      end

      def execute
        @results = llm_generate
      end

      def prompt
        <<-PROMPT
        You are an expert programmer in Ruby and at building Sublayer Agents.

        A Sublayer Agent can generate information from an LLM like this: #{File.read(File.expand_path(__dir__ + "/generate_code_given_description_agent.rb"))}

        Or a Sublayer Agent can perform a particular task like this: #{File.read(File.expand_path(__dir__ + "/save_file_contents_agent.rb"))}

        A Sublayer agent has an execute method, and initialize method that takes input, a result function that describes the expected output from the LLM (if it is using LLM assistance) and a prompt that may or may not use the input.
        The LLMAssistance module adds llm_generate which uses the prompt and llm_result_format and sends it to an LLM for processing
        The HumanAssistance module presents the string to a human for verification and modification.

        You need to build a new Sublayer agent that does the following:
        #{agent_description}

        Take a deep breath and think step by step before you start coding.
        PROMPT
      end
    end
  end
end
