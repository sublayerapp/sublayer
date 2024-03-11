module Sublayer
  module Components
    class ListOfObjects < OutputAdapter
      def initialize(options)
        @name = options[:name]
        @description = options[:description]
        @structure = options[:structure]
      end

      def to_hash
        {
          name: @name,
          description: @description,
          parameters: {
            type: "object",
            properties: {
              @name.to_sym => {
                type: "array",
                items: {
                  type: "object",
                  properties: @structure.transform_values { |desc| { type: "string", description: desc.capitalize } }
                }
              }
            }
          }
        }
      end
    end
  end
end
