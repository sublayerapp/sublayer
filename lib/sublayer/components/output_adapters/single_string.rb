module Sublayer
  module Components
    module OutputAdapters
      class SingleString
        attr_reader :name, :description

        def initialize(options)
          @name = options[:name]
          @description = options[:description]
        end

        def properties
          [OpenStruct.new(name: @name, type: 'string', description: @description, required: true)]
        end

        def json_formatted_properties
          {
            "#{@name}": {
              type: 'string',
              description: @description
            }
          }
        end

        def xml_formatted_properties
          <<-XML
            <parameter>
              <name>#{@name}</name>
              <type>string</type>
              <description>#{@description}</description>
              <required>true</required>
            </parameter>
          XML
        end
      end
    end
  end
end
