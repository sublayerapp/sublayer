# Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
# Sublayer.configuration.ai_model = "gemini-pro"

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
                    properties: format_properties(output_adapter),
                    required: output_adapter.properties.select(&:required).map(&:name)
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

      private
      def self.format_properties(output_adapter)
        output_adapter.properties.each_with_object({}) do |property, hash|
          hash[property.name] = {
            type: property.type.upcase,
            description: property.description
          }

          if property.enum
            hash[property.name][:enum] = property.enum
          end

          if property.items
            hash[property.name][:items] = property.items
          end
        end
      end
    end
  end
end
