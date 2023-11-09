module Sublayer
  module Components
    class OutputFunction
      attr_reader :name

      def initialize(options)
        @name = options[:name]
        @description = options[:description].capitalize
        @type = options[:type]
        @structure = options[:structure]
      end

      def to_hash
        case @type
        when :single_string
          single_string_hash
        when :list_of_objects
          list_of_objects_hash
        else
          {}
        end
      end

      private

      def single_string_hash
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

      def list_of_objects_hash
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
