require "spec_helper"

RSpec.describe Sublayer::Components::OutputAdapters do
  describe "#to_hash" do
    context "type: :single_string" do
      it "formats the hash output correctly" do
        output_adapter = Sublayer::Components::OutputAdapters.create(type: :single_string, name: "modified_file_contents", description: "The modified file contents")
        expect(output_adapter.to_hash).to eq(
          {
            name: "modified_file_contents",
            description: "The modified file contents",
            parameters: {
              type: "object",
              properties: {
                "modified_file_contents" => {
                  type: "string",
                  description: "The modified file contents"
                }
              }
            }
          }
        )
      end

      it "formats the xml output correctly" do
        output_adapter = Sublayer::Components::OutputAdapters.create(type: :single_string, name: "modified_file_contents", description: "The modified file contents")

        expect(output_adapter.to_xml).to eq(
          <<-XML
            <tool_description>
              <tool_name>modified_file_contents</tool_name>
              <tool_description>The modified file contents</tool_description>
              <parameters>
                <name>modified_file_contents</name>
                <type>string</type>
                <description>The modified file contents</description>
              </parameters>
            </tool_description>
          XML
        )
      end
    end
  end
end
