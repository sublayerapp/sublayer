# Sublayer.configuration.ai_provider = Sublayer::Providers::Groq
# Sublayer.configuration.ai_model = "mixtral-8x7b-32768"

module Sublayer
  module Providers
    class Groq
      def self.call(prompt:, output_adapter:)
        system_prompt = <<-PROMPT
        You have access to a set of tools to answer the prompt.

        You may call tools like this:
        <tool_calls>
          <tool_call>
            <tool_name>$TOOL_NAME</tool_name>
            <parameters>
              <#{output_adapter.name}>$VALUE</#{output_adapter.name}>
              ...
            </parameters>
          </tool_call>
        </tool_calls>

        Here are the tools available:
        <tools>
          #{output_adapter.to_xml}
        </tools>

        Respond only with valid xml.
        The entire response should be wrapped in a <response> tag.
        Your response should call a tool inside a <tool_calls> tag.
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

        text_containing_xml = response.dig("choices", 0, "message", "content")
        # xml = text_containing_xml.match(/\<response\>(.*?)\<\/response\>/m).to_s
        # response_xml = ::Nokogiri::XML(xml)
        tool_output = text_containing_xml.match(/\<#{output_adapter.name}\>(.*?)\<\/#{output_adapter.name}\>/m)[1]
        # function_output = response_xml.at_xpath("//response/function_calls/invoke/parameters/#{output_adapter.name}").children.to_s

        return tool_output
      end
    end
  end
end
