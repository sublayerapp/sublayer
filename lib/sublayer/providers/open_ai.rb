# Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
# Sublayer.configuration.ai_model = "gpt-4o"

module Sublayer
  module Providers
    class OpenAI
      def self.call(prompt:, output_adapter:)
        client = ::OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

        response = client.chat(
          parameters: {
            model: Sublayer.configuration.ai_model,
            messages: [
              {
                "role": "user",
                "content": prompt
              }
            ],
            tool_choice: { type: "function", function: { name: output_adapter.name }},
            tools: [
              {
                type: "function",
                function: {
                  name: output_adapter.name,
                  description: output_adapter.description,
                  parameters: {
                    type: "object",
                    properties: output_adapter.format_properties
                  },
                  required: output_adapter.format_required
                }
              }
            ]

          })

        message = response.dig("choices", 0, "message")

        raise "No function called" unless message["tool_calls"]

        function_body = message.dig("tool_calls", 0, "function", "arguments")

        raise "Error generating with OpenAI. Empty response. Try rewording your output adapter params to be from the perspective of the model. Full Response: #{response}" if function_body == "{}"

        results = JSON.parse(function_body)[output_adapter.name]
      end
    end
  end
end
