module Sublayer
  module Components
    class SingleString < OutputFunction
      def initialize(options)
        @name = options[:name]
        @description = options[:description]
      end

      def to_hash
        {
          name: @name,
          description: @description,
          parameters: {
            type: "object",
            properties: {
              @name => {
                type: "string",
                description: @description
              }
            }
          }
        }
      end
    end
  end
end
