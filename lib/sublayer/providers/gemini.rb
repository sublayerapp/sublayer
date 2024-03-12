# Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
# Sublayer.configuration.ai_model = "gemini-pro"

module Sublayer
  module Providers
    class Gemini
      API_URL = "https://generativelanguage.googleapis.com/v1beta/models/#{Sublayer.configuration.ai_model}:generateContent?key=#{ENV['GEMINI_API_KEY']}"

      def self.call(prompt:, output_adapter:)
        response = HTTParty.post(
          API_URL,
          body: {
            tools: { function_declarations: [output_adapter.to_hash] },
            contents: { role: "user", parts: { text: prompt } }
          },
          headers: { "Content-Type" => "application/json" })

        part = response.dig('candidates', 0, 'content', 'parts', 0)
        raise "No function called" unless part['functionCall']

        args = part['functionCall']['args']
        args[output_adapter.name]
      end
    end
  end
end
