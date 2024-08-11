# *UNSTABLE* Gemini function calling API is in beta.
#            Provider is not recommended until API update.

# Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
# Sublayer.configuration.ai_model = "gemini-1.5-pro"

module Sublayer
  module Providers
    class Gemini
      def self.call(prompt:, output_adapter:)

        request_id = SecureRandom.uuid
        before_request = Time.now
        Sublayer.configuration.logger.log(:info, "Gemini API request", {
          model: Sublayer.configuration.ai_model,
          prompt: prompt,
          request_id: request_id
        })

        response = HTTParty.post(
          "https://generativelanguage.googleapis.com/v1beta/models/#{Sublayer.configuration.ai_model}:generateContent?key=#{ENV['GEMINI_API_KEY']}",
          body: {
            contents: {
              role: "user",
              parts: {
                text: "#{prompt}"
              },
            },
            tools: [{
              function_declarations: [
                {
                  name: output_adapter.name,
                  description: output_adapter.description,
                  parameters: {
                    type: "OBJECT",
                    properties: output_adapter.format_properties,
                    required: output_adapter.format_required
                  }
                }
              ]
            }],
            tool_config: {
              function_calling_config: {
                mode: "ANY",
                allowed_function_names: [output_adapter.name]
              }
            }
          }.to_json,
          headers: {
            "Content-Type" => "application/json"
          }
        )

        after_request = Time.now
        response_time = after_request - before_request

        Sublayer.configuration.logger.log(:info, "Gemini API response", {
          request_id: request_id,
          response_time: response_time,
          usage: {
            input_tokens: response["usageMetadata"]["promptTokenCount"],
            output_tokens: response["usageMetadata"]["candidatesTokenCount"],
            total_tokens: response["usageMetadata"]["totalTokenCount"]
          }
        })

        raise "Error generating with Gemini, error: #{response.body}" unless response.success?

        argument = response.dig("candidates", 0, "content", "parts", 0, "functionCall", "args", output_adapter.name)
      end
    end
  end
end
