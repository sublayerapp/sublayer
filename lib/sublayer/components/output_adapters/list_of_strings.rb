module Sublayer
  module Components
    module OutputAdapters
      class ListOfStrings
        attr_reader :name, :description

        def initialize(options)
          @name = options[:name]
          @description = options[:description]
        end

        def properties
          [
            OpenStruct.new(
              name: @name,
              type: 'array',
              description: @description,
              required: true,
              items: {
                type: 'string'
              }
            )
          ]
        end
      end
    end
  end
end
