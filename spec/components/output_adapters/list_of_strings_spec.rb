require "spec_helper"

RSpec.describe Sublayer::Components::OutputAdapters::ListOfStrings do
  describe "#initialize" do
    it "sets the name and description" do
      adapter = Sublayer::Components::OutputAdapters::ListOfStrings.new(name: "test_list", description: "A test list of strings")

      expect(adapter.name).to eq("test_list")
      expect(adapter.description).to eq("A test list of strings")
    end
  end

  describe "#properties" do
    it "returns an array with one item" do
      adapter = Sublayer::Components::OutputAdapters::ListOfStrings.new(name: "test_list", description: "A test list of strings")

      expect(adapter.properties).to be_an(Array)
      expect(adapter.properties.size).to eq(1)
    end

    it "returns an OpenStruct object" do
      adapter = Sublayer::Components::OutputAdapters::ListOfStrings.new(name: "test_list", description: "A test list of strings")

      expect(adapter.properties.first).to be_an(OpenStruct)
    end

    it "has the correct attributes" do
      adapter = Sublayer::Components::OutputAdapters::ListOfStrings.new(name: "test_list", description: "A test list of strings")

      expect(adapter.properties.first.name).to eq("test_list")
      expect(adapter.properties.first.type).to eq("array")
      expect(adapter.properties.first.description).to eq("A test list of strings")
      expect(adapter.properties.first.required).to eq(true)
      expect(adapter.properties.first.items).to eq( {type: "string"} )
    end
  end
end
