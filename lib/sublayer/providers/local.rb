# Sublayer.configuration.ai_provider = Sublayer::Providers::Local
# Sublayer.configuration.ai_model = "LLaMA_CPP"

module Sublayer
  module Providers
    class Local
      def self.call(prompt:, output_adapter:)
        system_prompt = <<-PROMPT
        You are a function calling AI agent
        You can call only one function at a time
        You are provided with function signatures within <tools></tools> XML tags.

        Please call a function and wait for results to be provided to you in the next iteration.
        Don't make assumptions about what values to plug into function arguments.

        Here are the available tools:
        <tools>
        #{output_adapter.to_hash.to_json}
        </tools>

        For the function call, return a json object with function name and arguments within <tool_call></tool_call> XML tags as follows:

        <tool_call>
        {"arguments": <args-dict>, "name": <function-name>}
        </tool_call>
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
              { "role": "system", "content": system_prompt },
              { "role": "user", "content": prompt }
            ]
          }.to_json
        )

        text_containing_xml = JSON.parse(response.body).dig("choices", 0, "message", "content")
        results = JSON.parse(::Nokogiri::XML(text_containing_xml).at_xpath("//tool_call").children.to_s.strip)
        function_output = results["arguments"][output_adapter.name]

        return function_output
      end
    end
  end
end
