module Sublayer
  module Components
    module OutputAdapters
      class SingleString
        attr_reader :name

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
end
