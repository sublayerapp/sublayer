# Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
# Sublayer.configuration.ai_model = "gemini-1.5-pro-latest"

module Sublayer
  module Providers
    class GeminiInternalServiceError < StandardError; end

    class Gemini15Pro
      def self.call(prompt:, output_adapter:)
        response = HTTParty.post(
          "https://generativelanguage.googleapis.com/v1beta/models/#{Sublayer.configuration.ai_model}:generateContent?key=#{ENV['GEMINI_API_KEY']}",
          body: {
            contents: [
              {
                role: "user",
                parts: {
                  text: "#{prompt}\n#{system_prompt}"
                }
              }
            ],
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
          },
          timeout: 600
        )

        raise GeminiInternalServiceError, "Error generating with Gemini, error: #{response.body}" if response.code == 500

        raise "Error generating with Gemini, error: #{response.body}" unless response.success?

        output = response.dig("candidates", 0, "content", "parts", 0, "text")

        parsed_output = JSON.parse(output)[output_adapter.name]
      end

      def self.system_prompt
        <<-SYSTEM_PROMPT
        CRITICAL INSTRUCTIONS:
        **Backticks**: Do not use triple backticks in any form.
          - Instead of:
            ```
            pwd
            ```
            ```ruby
            puts "hello world"
            ```
            ```bash
            rails generate new my_app
            ```
          - Use:
            %%%
            pwd
            %%%
            %%%ruby
            puts "hello world"
            %%%
            %%%bash
            rails generate new my_app
            %%%
        SYSTEM_PROMPT
      end
    end
  end
end
