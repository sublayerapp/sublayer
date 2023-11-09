require "spec_helper"

RSpec.describe Sublayer::Components::OutputFunction do
  describe "#to_hash" do
    context "type: :single_string" do
      it "formats the hash output correctly" do
        output_function = Sublayer::Components::OutputFunction.new(type: :single_string, name: "modified_file_contents", description: "the modified file contents")
        expect(output_function.to_hash).to eq(
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
    end

    context "type: :list_of_objects" do
      it "formats the hash output correctly" do
        output_function = Sublayer::Components::OutputFunction.new(
          type: :list_of_objects,
          name: "retrieved_steps",
          description: "The retrieved steps for performing the given coding task",
          structure: {
            category: "The category of the step",
            command: "The command to run on the command line",
            description: "The description of what the command is for"
          }
        )

        expect(output_function.to_hash).to eq(
          {
            name: "retrieved_steps",
            description: "The retrieved steps for performing the given coding task",
            parameters: {
              type: "object",
              properties: {
                retrieved_steps: {
                  type: "array",
                  items: {
                    type: "object",
                    properties: {
                      category: {
                        type: "string",
                        description: "The category of the step"
                      },
                      command: {
                        type: "string",
                        description: "The command to run on the command line"
                      },
                      description: {
                        type: "string",
                        description: "The description of what the command is for"
                      }
                    }
                  }
                }
              }
            }
          }
        )
      end
    end
  end
end
