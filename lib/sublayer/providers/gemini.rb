# Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
# Sublayer.configuration.ai_model = "gemini-pro"

module Sublayer
  module Providers
    class Gemini
      def self.call(prompt:, output_adapter:, images: [])
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
          <tool>
            #{output_adapter.to_xml}
          </tool>
        </tools>

        Respond only with valid xml.
        The entire response should be wrapped in a <response> tag.
        Your response should call a tool inside a <tool_calls> tag.
        PROMPT

        response = HTTParty.post(
          "https://generativelanguage.googleapis.com/v1beta/models/#{Sublayer.configuration.ai_model}:generateContent?key=#{ENV['GEMINI_API_KEY']}",
          body: {
            contents: { role: "user", parts: { text: "#{system_prompt}\n#{prompt}" } }
          }.to_json,
          headers: {
            "Content-Type" => "application/json"
          }
        )

        raise "Error generating with Gemini, error: #{response.body}" unless response.success?

        text_containing_xml = response.dig('candidates', 0, 'content', 'parts', 0, 'text')
        tool_output = Nokogiri::HTML.parse(text_containing_xml.match(/\<#{output_adapter.name}\>(.*?)\<\/#{output_adapter.name}\>/m)[1]).text

        raise "Gemini did not format response, error: #{response.body}" unless tool_output
        return tool_output
      end
    end
  end
end
