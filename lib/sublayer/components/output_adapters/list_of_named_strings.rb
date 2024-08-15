module Sublayer
  module Components
    module OutputAdapters
      class ListOfNamedStrings
        attr_reader :name, :description, :attributes, :item_name

        def initialize(options)
          @name = options[:name]
          @item_name = options[:item_name]
          @description = options[:description]
          @attributes = options[:attributes]
        end

        def properties
          [
            OpenStruct.new(
              name: @name,
              type: "array",
              description: @description,
              required: true,
              items: OpenStruct.new(
                type: "object",
                description: "a single #{@item_name}",
                name: @item_name,
                properties: @attributes.map do |attribute|
                  OpenStruct.new(
                    type: "string",
                    name: attribute[:name],
                    description: attribute[:description],
                    required: true
                  )
                end
              )
            )
          ]
        end

        def materialize_result(raw_results)
          raw_results.map do |raw_result|
            OpenStruct.new(
              @attributes.map { |attribute| [attribute[:name], raw_result[attribute[:name]]] }.to_h
            )
          end
        end
      end
    end
  end
end
