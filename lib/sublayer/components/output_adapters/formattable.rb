module Sublayer
  module Components
    module OutputAdapters
      module Formattable
        def format_properties
          build_json_schema(self.properties)
        end

        def build_json_schema(props)
          formatted_properties = {}

          props.map do |prop|
            formatted_property = format_property(prop)
            formatted_properties[prop.name.to_sym] = formatted_property
          end

          formatted_properties
        end

        def format_property(property)
          result = {
            type: property.type,
            description: property.description
          }

          result[:enum] = property.enum if property.respond_to?(:enum) && property.enum
          result[:default] = property.default if property.respond_to?(:default) && !property.default.nil?
          result[:minimum] = property.minimum if property.respond_to?(:minimum) && !property.minimum.nil?
          result[:maximum] = property.maximum if property.respond_to?(:maximum) && !property.maximum.nil?

          case property.type
          when 'array'
            result[:items] = property.items.is_a?(OpenStruct) ? format_property(property.items) : property.items
          when 'object'
            result[:properties] = build_json_schema(property.properties) if property.properties
          end

          result
        end

        def format_required
          self.properties.select(&:required).map(&:name)
        end
      end
    end
  end
end
