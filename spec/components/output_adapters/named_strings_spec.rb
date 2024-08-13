require "spec_helper"

RSpec.describe Sublayer::Components::OutputAdapters::NamedStrings do
  let(:name) { 'test_adapter' }
  let(:description) { 'Test adapter description' }

  let(:attributes) do
    [
      { name: "field1", description: "Description of field1" },
      { name: "field2", description: "Description of field2" }
    ]
  end

  let(:output_adapter) { described_class.new(name: name, description: description, attributes: attributes) }

  describe "#initialize" do
    it "sets the name, description, and attributes" do
      expect(output_adapter.name).to eq(name)
      expect(output_adapter.description).to eq(description)
      expect(output_adapter.attributes).to eq(attributes)
    end
  end

  describe "#properties" do
    it "returns an array with one OpenStruct object" do
      properties = output_adapter.properties
      expect(properties).to be_an(Array)
      expect(properties.size).to eq(1)
      expect(properties.first).to be_an(OpenStruct)
    end

    it "sets the correct attributes for the main property" do
      property = output_adapter.properties.first
      expect(property.name).to eq(name)
      expect(property.description).to eq(description)
      expect(property.required).to eq(true)
      expect(property.type).to eq("object")
    end

    it "sets the correct nested properties" do
      nested_properties = output_adapter.properties.first.properties
      expect(nested_properties[0].name).to eq("field1")
      expect(nested_properties[0].type).to eq("string")
      expect(nested_properties[0].description).to eq("Description of field1")
      expect(nested_properties[0].required).to eq(true)
      expect(nested_properties[1].name).to eq("field2")
      expect(nested_properties[1].type).to eq("string")
      expect(nested_properties[1].description).to eq("Description of field2")
      expect(nested_properties[1].required).to eq(true)
    end
  end
end
