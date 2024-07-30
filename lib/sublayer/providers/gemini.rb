# *UNSTABLE* Gemini function calling API is in beta.
#            Provider is not recommended until API update.

# Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
# Sublayer.configuration.ai_model = "gemini-1.5-pro"

module Sublayer
  module Providers
    class Gemini
      def self.call(prompt:, output_adapter:)
        response = HTTParty.post(
          "https://generativelanguage.googleapis.com/v1beta/models/#{Sublayer.configuration.ai_model}:generateContent?key=#{ENV['GEMINI_API_KEY']}",
          body: {
            contents: {
              role: "user",
              parts: {
                text: "#{prompt}"
              },
            },
            tools: {
              functionDeclarations: [
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
            },
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

        raise "Error generating with Gemini, error: #{response.body}" unless response.success?

        argument = response.dig("candidates", 0, "content", "parts", 0, "functionCall", "args", output_adapter.name)
      end
    end
  end
end
