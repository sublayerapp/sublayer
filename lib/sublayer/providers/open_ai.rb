# Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
# Sublayer.configuration.ai_model = "gpt-4o-2024-08-06"

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
            response_format: {
              type: "json_schema",
              json_schema: {
                name: "response",
                strict: true,
                schema: {
                  type: "object",
                  additionalProperties: false,
                  properties: output_adapter.format_properties,
                  required: output_adapter.format_required
                }
              }
            }
          }
        )

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

        JSON.parse(message["content"])[output_adapter.name]
      end
    end
  end
end
