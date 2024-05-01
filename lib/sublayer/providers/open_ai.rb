# Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
# Sublayer.configuration.ai_model = "gpt-4-turbo-preview"

module Sublayer
  module Providers
    class OpenAI
      class << self
        def call(prompt:, output_adapter:)
          client = ::OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

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
                      properties: format_properties(output_adapter)
                    },
                    required: [output_adapter.properties.select(&:required).map(&:name)]
                  }
                }
              ]

            })

          message = response.dig("choices", 0, "message")

          raise "No function called" unless message["tool_calls"].length > 0

          function_body = message.dig("tool_calls", 0, "function", "arguments")
          JSON.parse(function_body)[output_adapter.name]
        end

        private
        def format_properties(output_adapter)
          # format output adapter properties as json
          output_adapter.properties.each_with_object({}) do |property, hash|
            hash[property.name] = {
              type: property.type,
              description: property.description
            }
          end
        end
      end
    end
  end
end
