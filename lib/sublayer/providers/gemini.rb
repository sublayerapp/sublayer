# Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
# Sublayer.configuration.ai_model = "gemini-1.5-flash-latest"

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
            generationConfig: {
              responseMimeType: "application/json",
              responseSchema: {
                type: "OBJECT",
                properties: output_adapter.format_properties,
                required: output_adapter.format_required
              }
            }
          }.to_json,
          headers: {
            "Content-Type" => "application/json"
          }
        )

        after_request = Time.now
        response_time = after_request - before_request

        raise "Error generating with Gemini, error: #{response.body}" unless response.success?

        Sublayer.configuration.logger.log(:info, "Gemini API response", {
          request_id: request_id,
          response_time: response_time,
          usage: {
            input_tokens: response["usageMetadata"]["promptTokenCount"],
            output_tokens: response["usageMetadata"]["candidatesTokenCount"],
            total_tokens: response["usageMetadata"]["totalTokenCount"]
          }
        })

        output = response.dig("candidates", 0, "content", "parts", 0, "text")

        parsed_output = JSON.parse(output)[output_adapter.name]
      end
    end
  end
end
