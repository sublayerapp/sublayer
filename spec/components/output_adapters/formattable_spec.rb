require "pry"
require 'spec_helper'

RSpec.describe Sublayer::Components::OutputAdapters::Formattable do
  let(:test_class) do
    Class.new do
      include Sublayer::Components::OutputAdapters::Formattable

      attr_reader :properties

      def initialize
        @properties = []
      end

      def add_property(property)
        @properties << property
      end
    end
  end

  let(:formattable) { test_class.new }

  describe '#format_properties' do
    context "object" do
      context "single object" do
        it "formats object correctly" do
          formattable.add_property(OpenStruct.new(name: 'object', type: 'object', description: 'The object', required: true, properties: [
            OpenStruct.new(name: 'name', type: 'string', description: 'The name', required: true),
            OpenStruct.new(name: 'age', type: 'integer', description: 'The age', required: false)
          ]))

          expect(formattable.format_properties).to eq({
            object: {
              type: 'object',
              description: 'The object',
              properties: {
                name: { type: 'string', description: 'The name' },
                age: { type: 'integer', description: 'The age' }
              }
            }
          })
        end
      end

      context "nested object do" do
        it "formats the object correctly" do
          formattable.add_property(OpenStruct.new(name: 'object', type: 'object', description: 'The object', required: true, properties: [
            OpenStruct.new(name: 'name', type: 'string', description: 'The name', required: true),
            OpenStruct.new(name: 'age', type: 'integer', description: 'The age', required: false),
            OpenStruct.new(name: 'address', type: 'object', description: 'The address', required: true, properties: [
              OpenStruct.new(name: 'street', type: 'string', description: 'The street', required: true),
              OpenStruct.new(name: 'city', type: 'string', description: 'The city', required: true),
              OpenStruct.new(name: 'state', type: 'string', description: 'The state', required: true),
              OpenStruct.new(name: 'zip', type: 'string', description: 'The zip', required: true)
            ])
          ]))

          expect(formattable.format_properties).to eq({
            object: {
              type: 'object',
              description: 'The object',
              properties: {
                name: { type: 'string', description: 'The name' },
                age: { type: 'integer', description: 'The age' },
                address: {
                  type: 'object',
                  description: 'The address',
                  properties: {
                    street: { type: 'string', description: 'The street' },
                    city: { type: 'string', description: 'The city' },
                    state: { type: 'string', description: 'The state' },
                    zip: { type: 'string', description: 'The zip' }
                  }
                }
              }
            }
          })
        end
      end
    end

    it 'formats basic properties correctly' do
      formattable.add_property(OpenStruct.new(name: 'name', type: 'string', description: 'The name', required: true))
      formattable.add_property(OpenStruct.new(name: 'age', type: 'integer', description: 'The age', required: false))

      expect(formattable.format_properties).to eq({
        name: { type: 'string', description: 'The name' },
        age: { type: 'integer', description: 'The age' }
      })
    end

    it 'includes enum when present' do
      formattable.add_property(OpenStruct.new(name: 'color', type: 'string', description: 'The color', enum: ['red', 'green', 'blue']))

      expect(formattable.format_properties[:color][:enum]).to eq(['red', 'green', 'blue'])
    end

    it 'includes default when present' do
      formattable.add_property(OpenStruct.new(name: 'is_active', type: 'boolean', description: 'Is active', default: true))

      expect(formattable.format_properties[:is_active][:default]).to eq(true)
    end

    it 'includes minimum and maximum when present' do
      formattable.add_property(OpenStruct.new(name: 'quantity', type: 'integer', description: 'The quantity', minimum: 0, maximum: 100))

      expect(formattable.format_properties[:quantity][:minimum]).to eq(0)
      expect(formattable.format_properties[:quantity][:maximum]).to eq(100)
    end

    it 'includes items for array types' do
      formattable.add_property(OpenStruct.new(name: 'tags', type: 'array', description: 'The tags', items: { type: 'string' }))

      expect(formattable.format_properties[:tags][:items]).to eq({ type: 'string' })
    end

    it 'handles properties with multiple attributes' do
      formattable.add_property(OpenStruct.new(
        name: 'score',
        type: 'number',
        description: 'The score',
        minimum: 0,
        maximum: 100,
        default: 50,
        enum: [0, 25, 50, 75, 100]
      ))

      expect(formattable.format_properties[:score]).to eq({
        type: 'number',
        description: 'The score',
        minimum: 0,
        maximum: 100,
        default: 50,
        enum: [0, 25, 50, 75, 100]
      })
    end

    it 'handles properties without optional attributes' do
      formattable.add_property(OpenStruct.new(name: 'description', type: 'string', description: 'The description'))

      expect(formattable.format_properties[:description]).to eq({
        type: 'string',
        description: 'The description'
      })
    end
  end

  describe '#format_required' do
    it 'returns an array of required property names' do
      formattable.add_property(OpenStruct.new(name: 'id', type: 'integer', description: 'The ID', required: true))
      formattable.add_property(OpenStruct.new(name: 'name', type: 'string', description: 'The name', required: true))
      formattable.add_property(OpenStruct.new(name: 'optional', type: 'string', description: 'Optional field', required: false))

      expect(formattable.format_required).to eq(['id', 'name'])
    end

    it 'returns an empty array when no properties are required' do
      formattable.add_property(OpenStruct.new(name: 'optional1', type: 'string', description: 'Optional field 1', required: false))
      formattable.add_property(OpenStruct.new(name: 'optional2', type: 'integer', description: 'Optional field 2', required: false))

      expect(formattable.format_required).to eq([])
    end
  end
end
