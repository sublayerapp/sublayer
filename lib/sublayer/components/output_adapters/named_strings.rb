module Sublayer
  module Components
    module OutputAdapters
      class NamedStrings
        attr_reader :name, :description, :attributes

        def initialize(options)
          @name = options[:name]
          @description = options[:description]
          @attributes = options[:attributes]
        end

        def properties
          [
            OpenStruct.new(
              name: @name,
              type: "object",
              description: @description,
              required: true,
              properties: @attributes.map { |attribute| OpenStruct.new(type: "string", description: attribute[:description], required: true, name: attribute[:name]) }
            )
          ]
        end

        def materialize_result(raw_result)
          OpenStruct.new( @attributes.map { |attribute| [attribute[:name], raw_result[attribute[:name]]] }.to_h)
        end
      end
    end
  end
end
