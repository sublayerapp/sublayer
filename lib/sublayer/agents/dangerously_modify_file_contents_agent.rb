module Sublayer
  module Agents
    class DangerouslyModifyFileContentsAgent
      include Sublayer::Capabilities::LLMAssistance
      include Sublayer::Capabilities::HumanAssistance

      attr_reader :file_path, :description, :technologies, :results

      llm_result_format type: :single_string,
        name: "modified_file_contents",
        description: "The modified file contents"

      def initialize(file_path:, description:, technologies:)
        @file_path = file_path
        @description = description
        @technologies = technologies
      end

      def execute
        @results = llm_generate
      end

      def prompt
        <<-PROMPT
        You are an expert programmer in #{technologies.join(", ")}.

        Here are the original file contents:

        #{File.read(@file_path)}

        The description of the changes to make is: #{description}

        Please make the necessary changes to this file.
        PROMPT
      end
    end
  end
end
