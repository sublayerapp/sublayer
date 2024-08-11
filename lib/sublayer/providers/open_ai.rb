# Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
# Sublayer.configuration.ai_model = "gpt-4o"

module Sublayer
  module Providers
    class OpenAI
      def self.call(prompt:, output_adapter:)
        client = ::OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

        request_id = SecureRandom.uuid

        Sublayer.configuration.logger.log(:info, "OpenAI API request", {
          model: Sublayer.configuration.ai_model,
          prompt: prompt,
          request_id: request_id,
        })

        before_request = Time.now

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

        after_request = Time.now
        response_time = after_request - before_request

        Sublayer.configuration.logger.log(:info, "OpenAI API response", {
          request_id: request_id,
          response_time: response_time,
          usage: {
            input_tokens: response["usage"]["prompt_tokens"],
            output_tokens: response["usage"]["completion_tokens"],
            total_tokens: response["usage"]["total_tokens"]
          }
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
