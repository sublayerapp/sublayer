require "spec_helper"

RSpec.describe Sublayer::Components::OutputAdapters do
  context "class:" do
    it "class: 'String'" do
      output_adapter = Sublayer::Components::OutputAdapters.create(
        class: "Sublayer::Components::OutputAdapters::SingleString",
        name: "modified_file_contents",
        description: "The modified file contents"
      )
      expect(output_adapter).to be_a(Sublayer::Components::OutputAdapters::SingleString)
    end

    it "class: Constant" do
      output_adapter = Sublayer::Components::OutputAdapters.create(
        class: Sublayer::Components::OutputAdapters::SingleString,
        name: "modified_file_contents",
        description: "The modified file contents"
      )
      expect(output_adapter).to be_a(Sublayer::Components::OutputAdapters::SingleString)
    end
  end
end
