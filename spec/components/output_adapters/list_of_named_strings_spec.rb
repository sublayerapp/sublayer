require "spec_helper"

RSpec.describe Sublayer::Components::OutputAdapters::ListOfNamedStrings do
  let(:name) { 'test_adapter' }
  let(:description) { 'Test adapter description' }
  let(:attributes) do
    [
      { name: "field1", description: "Description of field1" },
      { name: "field2", description: "Description of field2" },
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
      expect(property.type).to eq("array")
    end

    it "sets the correct nested properties for items" do
      items = output_adapter.properties.first.items
      expect(items).to be_a(OpenStruct)
      expect(items.type).to eq("object")
      expect(items.properties).to be_an(Array)
      expect(items.properties.size).to eq(2)
      expect(items.properties.first).to be_an(OpenStruct)
      expect(items.properties.first.name).to eq("field1")
      expect(items.properties.first.type).to eq("string")
      expect(items.properties.first.description).to eq("Description of field1")
      expect(items.properties.first.required).to eq(true)
      expect(items.properties.last.name).to eq("field2")
      expect(items.properties.last.type).to eq("string")
      expect(items.properties.last.description).to eq("Description of field2")
      expect(items.properties.last.required).to eq(true)
    end
  end

  describe "#materialize_result" do
    it "converts the raw result to an array of OpenStruct objects" do
      raw_result = [
        { "field1" => "value1", "field2" => "value2" },
        { "field1" => "value3", "field2" => "value4" }
      ]

      result = output_adapter.materialize_result(raw_result)
      expect(result).to be_an(Array)
      expect(result.size).to eq(2)
      expect(result.all? { |item| item.is_a?(OpenStruct) }).to be true
      expect(result.first.field1).to eq("value1")
      expect(result.first.field2).to eq("value2")
      expect(result.last.field1).to eq("value3")
      expect(result.last.field2).to eq("value4")
    end
  end
end
