# Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
# Sublayer.configuration.ai_model = "gemini-pro"

module Sublayer
  module Providers
    class Gemini
      def self.call(prompt:, output_adapter:)
        system_prompt = <<-PROMPT
          You have access to a set of tools to answer the prompt.

          You may call tools like this:
          <tool_calls>
            <tool_call>
              <tool_name>$TOOL_NAME</tool_name>
              <parameters>
                <$PARAMETER_NAME>$VALUE</$PARAMETER_NAME>
                ...
              </parameters>
            </tool_call>
          </tool_calls>

          Here are the tools available:
          <tools>
            <tool_description>
              <tool_name>#{output_adapter.name}</tool_name>
              <tool_description>#{output_adapter.description}</tool_description>
              <parameters>
                #{format_properties(output_adapter)}
              </parameters>
            </tool_description>
          </tools>

          Respond only with valid xml.
          The entire response should be wrapped in a <response> tag.
          Your response should call a tool inside a <tool_calls> tag.
        PROMPT



        response = HTTParty.post(
          "https://generativelanguage.googleapis.com/v1beta/models/#{Sublayer.configuration.ai_model}:generateContent?key=#{ENV['GEMINI_API_KEY']}",
          body: {
            contents: { role: "user", parts: { text: prompt } },
            tools: [
              {function_declarations: [{
                name: 'my_function',
                parameters: {
                  type: "object",
                  properties: format_properties(output_adapter),
                  required: output_adapter.properties.select(&:required).map(&:name)
                },
              }]}
            ],
            tool_config: {
              function_calling_config: {
                mode: 'ANY'
              }
            }
            generationConfig: {
              temperature: 0,
            }
          }.to_json,
          headers: {
            "Content-Type" => "application/json"
          }
        )

        raise "Error generating with Gemini, error: #{response.body}" unless response.success?

        function_args = response.dig('candidates', 0, 'content', 'parts', 0, 'functionCall', 'args')
        function_args[output_adapter.name]
      end

      private
      def self.format_properties(output_adapter)
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
