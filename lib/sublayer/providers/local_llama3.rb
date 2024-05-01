# Sublayer.configuration.ai_provider = Sublayer::Providers::Local
# Sublayer.configuration.ai_model = "Llama3"

module Sublayer
  module Providers
    class LocalLlama3
      class << self
        def call(prompt:, output_adapter:)
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
            <tool_description>
              <tool_name>#{output_adapter.name}</tool_name>
              <tool_description>#{output_adapter.description}</tool_description>
              <parameters>
                #{format_properties(output_adapter)}
              </parameters>
            </tool_description>
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
        private
        def format_properties(output_adapter)
          output_adapter.properties.each_with_object("") do |property, xml|
            xml << "<parameter>"
            xml << "<name>#{property.name}</name>"
            xml << "<type>#{property.type}</type>"
            xml << "<description>#{property.description}</description>"
            xml << "</parameter>"
          end
        end
      end
    end
  end
end
