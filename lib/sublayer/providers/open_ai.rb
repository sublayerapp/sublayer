require "openai"

module Sublayer
  module Providers
    class OpenAI
      def self.call(prompt:, output_adapter:)
        client = ::OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

        response = client.chat(
          parameters: {
            model: Sublayer.configuration.ai_model,
            messages: [
              {
                "role": "user",
                "content": prompt
              }
            ],
            function_call: { name: output_adapter.name },
            functions: [
              output_adapter.to_hash
            ]
          })

        message = response.dig("choices", 0, "message")
        raise "No function called" unless message["function_call"]

        function_name = message.dig("function_call", output_adapter.name)
        args_from_llm = message.dig("function_call", "arguments")
        JSON.parse(args_from_llm)[output_adapter.name]
      end
    end
  end
end
