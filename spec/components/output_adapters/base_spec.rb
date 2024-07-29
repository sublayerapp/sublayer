require 'spec_helper'

RSpec.describe Sublayer::Components::OutputAdapters::Base do
  let(:adapter_class) do
    Class.new(described_class) do
      def properties
        @properties ||= []
      end

      def add_property(property)
        properties << property
      end
    end
  end

  let(:adapter) { adapter_class.new }

  describe '#format_properties' do
    it 'formats basic properties correctly' do
      adapter.add_property(OpenStruct.new(name: 'name', type: 'string', description: 'The name', required: true))
      adapter.add_property(OpenStruct.new(name: 'age', type: 'integer', description: 'The age', required: false))

      expect(adapter.format_properties).to eq({
        name: { type: 'string', description: 'The name' },
        age: { type: 'integer', description: 'The age' }
      })
    end

    it 'includes enum when present' do
      adapter.add_property(OpenStruct.new(name: 'color', type: 'string', description: 'The color', enum: ['red', 'green', 'blue']))

      expect(adapter.format_properties[:color][:enum]).to eq(['red', 'green', 'blue'])
    end

    it 'includes default when present' do
      adapter.add_property(OpenStruct.new(name: 'is_active', type: 'boolean', description: 'Is active', default: true))

      expect(adapter.format_properties[:is_active][:default]).to eq(true)
    end

    it 'includes minimum and maximum when present' do
      adapter.add_property(OpenStruct.new(name: 'quantity', type: 'integer', description: 'The quantity', minimum: 0, maximum: 100))

      expect(adapter.format_properties[:quantity][:minimum]).to eq(0)
      expect(adapter.format_properties[:quantity][:maximum]).to eq(100)
    end

    it 'includes items for array types' do
      adapter.add_property(OpenStruct.new(name: 'tags', type: 'array', description: 'The tags', items: { type: 'string' }))

      expect(adapter.format_properties[:tags][:items]).to eq({ type: 'string' })
    end

    it 'handles properties with multiple attributes' do
      adapter.add_property(OpenStruct.new(
        name: 'score',
        type: 'number',
        description: 'The score',
        minimum: 0,
        maximum: 100,
        default: 50,
        enum: [0, 25, 50, 75, 100]
      ))

      expect(adapter.format_properties[:score]).to eq({
        type: 'number',
        description: 'The score',
        minimum: 0,
        maximum: 100,
        default: 50,
        enum: [0, 25, 50, 75, 100]
      })
    end

    it 'handles properties without optional attributes' do
      adapter.add_property(OpenStruct.new(name: 'description', type: 'string', description: 'The description'))

      expect(adapter.format_properties[:description]).to eq({
        type: 'string',
        description: 'The description'
      })
    end
  end

  describe '#format_required' do
    it 'returns an array of required property names' do
      adapter.add_property(OpenStruct.new(name: 'id', type: 'integer', description: 'The ID', required: true))
      adapter.add_property(OpenStruct.new(name: 'name', type: 'string', description: 'The name', required: true))
      adapter.add_property(OpenStruct.new(name: 'optional', type: 'string', description: 'Optional field', required: false))

      expect(adapter.format_required).to eq(['id', 'name'])
    end

    it 'returns an empty array when no properties are required' do
      adapter.add_property(OpenStruct.new(name: 'optional1', type: 'string', description: 'Optional field 1', required: false))
      adapter.add_property(OpenStruct.new(name: 'optional2', type: 'integer', description: 'Optional field 2', required: false))

      expect(adapter.format_required).to eq([])
    end
  end
end