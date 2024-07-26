# Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
# Sublayer.configuration.ai_model ="claude-3-opus-20240229"

module Sublayer
  module Providers
    class Claude
      def self.call(prompt:, output_adapter:)
        response = HTTParty.post(
          "https://api.anthropic.com/v1/messages",
          headers: {
            "x-api-key": ENV.fetch("ANTHROPIC_API_KEY"),
            "anthropic-version": "2023-06-01",
            "content-type": "application/json",
            "anthropic-beta": "tools-2024-04-04"
          },
          body: {
            model: Sublayer.configuration.ai_model,
            max_tokens: 4096,
            tools: [
              {
                name: output_adapter.name,
                description: output_adapter.description,
                input_schema: {
                  type: "object",
                  properties: output_adapter.json_formatted_properties,
                  required: output_adapter.properties.select(&:required).map(&:name)
                }
              }
            ],
            messages: [{ "role": "user", "content": prompt }]
          }.to_json
        )
        raise "Error generating with Claude, error: #{response.body}" unless response.code == 200

        function_input = JSON.parse(response.body).dig("content").find {|content| content['type'] == 'tool_use'}.dig("input")
        function_input[output_adapter.name]
      end
    end
  end
end
