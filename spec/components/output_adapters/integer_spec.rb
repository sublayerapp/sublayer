# require "spec_helper"

# RSpec.describe Sublayer::Components::OutputAdapters::Integer do
#   let(:name) { 'output_adapter_name' }
#   let(:description) { 'output_adapter_description' }
#   let(:output_adapter) { Sublayer::Components::OutputAdapters::Integer.new(name: name, description: description) }

#   describe '#name' do
#     it 'returns the name' do
#       expect(output_adapter.name).to eq(name)
#     end
#   end

#   describe '#description' do
#     it 'returns the description' do
#       expect(output_adapter.description).to eq(description)
#     end
#   end

#   describe '#properties' do
#     it 'returns an array with a single property' do
#       expect(output_adapter.properties).to be_an(Array)
#       expect(output_adapter.properties.length).to eq(1)
#       expect(output_adapter.properties.first).to be_an(OpenStruct)
#     end

#     describe 'the first property' do
#       let(:property) { output_adapter.properties.first }

#       it 'has a name' do
#         expect(property.name).to eq(name)
#       end

#       it 'has a type' do
#         expect(property.type).to eq('integer')
#       end

#       it 'has a description' do
#         expect(property.description).to eq(description)
#       end

#       it 'is required' do
#         expect(property.required).to eq(true)
#       end
#     end
#   end
# end
