# Sublayer.configuration.ai_provider = Sublayer::Providers::Local
# Sublayer.configuration.ai_model = "LLaMA_CPP"

module Sublayer
  module Providers
    class Local
      def self.call(prompt:, output_adapter:)
        system_prompt = <<-PROMPT
        You have access to a set of tools to respond to the prompt.

        You may call a tool with xml like this:
        <parameters>
          <#{output_adapter.name}>$VALUE</#{output_adapter.name}>
          ...
        </parameters>

        $VALUE should be replaced with the corresponding value you want to pass to the tool described below.

        Here are descriptions of the available tools:
        <tools>
          <tool>
            #{output_adapter.to_xml}
          </tool>
        </tools>

        Respond only with valid xml.
        Your response should call a tool with xml inside a <parameters> tag.
        PROMPT

        response = HTTParty.post(
          "http://localhost:8080/v1/chat/completions",
          headers: {
            "Authorization": "Bearer no-key",
            "Content-Type": "application/json"
          },
          body: {
            "model": Sublayer.configuration.ai_model,
            "messages": [
              { "role": "user", "content": "#{system_prompt}\n#{prompt}}" }
            ]
          }.to_json
        )

        text_containing_xml = response.dig("choices", 0, "message", "content")
        tool_output = Nokogiri::HTML.parse(text_containing_xml.match(/\<#{output_adapter.name}\>(.*?)\<\/#{output_adapter.name}\>/m)[1]).text
        raise "The response was not formatted correctly: #{response.body}" unless tool_output

        return tool_output
      end
    end
  end
end
