# Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
# Sublayer.configuration.ai_model = "gpt-4-turbo-preview"

module Sublayer
  module Providers
    class OpenAI
      class << self
        def call(prompt:, output_adapter:, images: [])
          client = ::OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

          response = client.chat(
            parameters: {
              model: Sublayer.configuration.ai_model,
              messages: [
                {
                  "role": "user",
                  "content": [
                    { type: 'text', text: prompt }
                  ] + image_messages(images)
                }
              ],
              function_call: { name: output_adapter.name },
              functions: [
                output_adapter.to_hash
              ]
            }
          )

          message = response.dig("choices", 0, "message")
          raise "No function called" unless message["function_call"]

          function_name = message.dig("function_call", output_adapter.name)
          args_from_llm = message.dig("function_call", "arguments")
          JSON.parse(args_from_llm)[output_adapter.name]
        end

        private

        def image_messages(images)
          images.map do |image|
            {
              type: 'image_url',
              image_url: { url: image }
            }
          end
        end
      end
    end
  end
end
