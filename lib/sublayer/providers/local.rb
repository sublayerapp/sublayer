# Sublayer.configuration.ai_provider = Sublayer::Providers::Local
# Sublayer.configuration.ai_model = "LLaMA_CPP"

module Sublayer
  module Providers
    class Local
      def initialize(prompt:, output_adapter:)
        response = HTTParty.post(
          "http://localhost:8080/v1/chat/completions",
          headers: {
            "Authorization": "Bearer no-key",
            "Content-Type": "application/json"
          },
          body: {
            "model": Sublayer.configuration.ai_model,
            "messages": [
              { "role": "system", "content": system_prompt(output_adapter: output_adapter) },
              { "role": "user", "content": prompt }
            ]
          }.to_json
        )

        text_containing_xml = JSON.parse(response.body).dig("choices", 0, "message", "content")
        xml = text_containing_xml.match(/\<response\>(.*?)\<\/response\>/m).to_s
        response_xml = Nokogiri::XML(xml)
        function_output = response_xml.at_xpath("//parameters/#{output_adapter.name}").children.to_s

        return function_output
      end

      private
      def system_prompt(output_adapter:)
        <<-PROMPT
        In this environment you have access to a set of tools you can use to answer the user's question.

        You may call them like this:
        <function_calls>
        <invoke>
          <tool_name>$TOOL_NAME</tool_name>
          <parameters>
          <#{output_adapter.name}>value</#{output_adapter.name}>
          ...
          </parameters>
        </invoke>
        </function_calls>

        Here are the tools available:
        <tools>
        #{output_adapter.to_xml}
        </tools>

        Respond only with valid xml.
        The entire response should be wrapped in a <response> tag.
        Any additional information not inside a tool call should go in a <scratch> tag.
        PROMPT
      end
    end
  end
end
