# Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
# Sublayer.configuration.ai_model ="claude-3-opus-20240229"

module Sublayer
  module Providers
    class Claude
      def self.call(prompt:, output_adapter:)
        system_prompt = <<-PROMPT
        In this environment you have access to a set of tools you can use to answer the user's question.

        You may call them like this:
        <function_calls>
        <invoke>
          <tool_name>$TOOL_NAME</tool_name>
          <parameters>
          <$PARAMETER_NAME>$PARAMETER_VALUE</$PARAMETER_NAME>
          ...
          </parameters>
        </invoke>
        </function_calls>

        Here are the tools available:
        <tools>
          <tool_description>
            <tool_name>#{output_adapter.name}</tool_name>
            <tool_description>#{output_adapter.description}</tool_description>
            <parameters>
              #{Claude.format_properties(output_adapter)}
            </parameters>
          </tool_description>
        </tools>

        Respond only with valid xml. The entire response should be wrapped in a <response> tag. Any additional information not inside a tool call should go in a <scratch> tag.
        PROMPT

        response = HTTParty.post(
          "https://api.anthropic.com/v1/messages",
          headers: {
            "x-api-key": ENV.fetch("ANTHROPIC_API_KEY"),
            "anthropic-version": "2023-06-01",
            "content-type": "application/json"
          },
          body: {
            model: Sublayer.configuration.ai_model,
            max_tokens: 4096,
            system: system_prompt,
            messages: [ { "role": "user", "content": prompt }]
          }.to_json
        )
        raise "Error generating with Claude, error: #{response.body}" unless response.code == 200

        text_containing_xml = JSON.parse(response.body).dig("content", 0, "text")
        function_output = Nokogiri::HTML.parse(text_containing_xml.match(/\<#{output_adapter.name}\>(.*?)\<\/#{output_adapter.name}\>/m)[1]).text

        raise "Claude did not format response, error: #{response.body}" unless function_output
        return function_output
      end

      private
      def self.format_properties(output_adapter)
        output_adapter.properties.each_with_object("") do |property, xml|
          xml << "<name>#{property.name}</name>"
          xml << "<type>#{property.type}</type>"
          xml << "<description>#{property.description}</description>"
        end
      end
    end
  end
end
