# Sublayer.configuration.ai_provider = Sublayer::Providers::Groq
# Sublayer.configuration.ai_model = "mixtral-8x7b-32768"

module Sublayer
  module Providers
    class Groq
      def self.call(prompt:, output_adapter:)
        system_prompt = <<-PROMPT
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

        response = HTTParty.post(
          "https://api.groq.com/openai/v1/chat/completions",
          headers: {
            "Authorization": "Bearer #{ENV["GROQ_API_KEY"]}",
            "Content-Type": "application/json"
          },
          body: {
            "messages": [{"role": "user", "content": "#{system_prompt}\n#{prompt}"}],
            "model": Sublayer.configuration.ai_model
          }.to_json
        )

        text_containing_xml = JSON.parse(response.body).dig("choices", 0, "message", "content")
        xml = text_containing_xml.match(/\<response\>(.*?)\<\/response\>/m).to_s
        response_xml = ::Nokogiri::XML(xml)
        function_output = response_xml.at_xpath("//response/function_calls/invoke/parameters/command").children.to_s

        return function_output
      end
    end
  end
end
