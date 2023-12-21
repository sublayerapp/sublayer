require "openai"

module Sublayer
  module Capabilities
    module LLMAssistance
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def llm_result_format(type:, name:, description:)
          output_function = Sublayer::Components::OutputFunction.create(type: type, name: name, description: description)
          const_set(:OUTPUT_FUNCTION, output_function)
        end
      end

      def llm_generate
        client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

        response = client.chat(
          parameters: {
            model: "gpt-4-1106-preview",
            messages: [
              {
                "role": "user",
                "content": prompt
              }
            ],
            function_call: { name: self.class::OUTPUT_FUNCTION.name },
            functions: [
              self.class::OUTPUT_FUNCTION.to_hash
            ]
          }
        )

        message = response.dig("choices", 0, "message")
        raise "No function called" unless message["function_call"]

        function_name = message.dig("function_call", self.class::OUTPUT_FUNCTION.name)
        args_from_llm = message.dig("function_call", "arguments")
        JSON.parse(args_from_llm)[self.class::OUTPUT_FUNCTION.name]
      end
    end
  end
end
