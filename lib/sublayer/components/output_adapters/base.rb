module Sublayer
  module Components
    module OutputAdapters
      class Base
        def format_properties
          formatted_properties = {}
          self.properties.each do |prop|
            property = {
              type: prop.type,
              description: prop.description
            }

            property[:enum] = prop.enum if prop.respond_to?(:enum) && prop.enum
            property[:default] = prop.default if prop.respond_to?(:default) && !prop.default.nil?
            property[:minimum] = prop.minimum if prop.respond_to?(:minimum) && !prop.minimum.nil?
            property[:maximum] = prop.maximum if prop.respond_to?(:maximum) && !prop.maximum.nil?
            property[:items] = prop.items if prop.respond_to?(:items) && prop.items
            formatted_properties[prop.name.to_sym] = property
          end
          formatted_properties
        end

        def format_required
          self.properties.select(&:required).map(&:name)
        end

        def properties
          raise NotImplementedError, "#{self.class} must implement properties method"
        end
      end
    end
  end
end
