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
        #{output_adapter.to_xml}
        </tools>

        Respond only with valid xml. The entire response should be wrapped in a <response> tag. Any additional information not inside a tool call should go in a <scratch> tag.
        PROMPT

        response = HTTParty.post(
          "https://api.anthropic.com/v1/messages",
          headers: {
            "x-api-key": ENV["ANTHROPIC_API_KEY"],
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
        xml = text_containing_xml.match(/\<response\>(.*?)\<\/response\>/m).to_s
        response_xml = ::Nokogiri::XML(xml)
        function_output = response_xml.at_xpath("//response/function_calls/invoke/parameters/#{output_adapter.name}").children.to_s

        return function_output
      end
    end
  end
end
