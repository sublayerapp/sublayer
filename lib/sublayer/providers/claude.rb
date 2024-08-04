# Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
# Sublayer.configuration.ai_model ="claude-3-5-sonnet-20240620"

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
                  properties: output_adapter.format_properties,
                  required: output_adapter.format_required
                }
              }
            ],
            tool_choice: { type: "tool", name: output_adapter.name },
            messages: [{ "role": "user", "content": prompt }]
          }.to_json
        )

        raise "Error generating with Claude, error: #{response.body}" unless response.code == 200

        tool_use = JSON.parse(response.body).dig("content").find { |content| content['type'] == 'tool_use' && content['name'] == output_adapter.name }

        raise "Error generating with Claude, error: No function called. If the answer is in the response, try rewording your prompt or output adapter name to be from the perspective of the model. Response: #{response.body}" unless tool_use

        tool_use.dig("input")[output_adapter.name]
      end
    end
  end
end
