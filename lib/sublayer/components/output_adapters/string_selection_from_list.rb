module Sublayer
  module Components
    module OutputAdapters
      class StringSelectionFromList < Base
        attr_reader :name, :description, :options

        def initialize(options)
          @name = options[:name]
          @description = options[:description]
          @list = options[:options]
        end

        def properties
          [OpenStruct.new(name: @name, type: 'string', description: @description, required: true, enum: @list)]
        end

        def load_instance_data(generator)
          case @list
          when Proc
            @list = generator.instance_exec(&@list)
          when Symbol
            @list = generator.send(@list)
          else
            @list
          end
        end

        def json_formatted_properties
          {
            "#{@name}": {
              type: 'string',
              description: @description,
              enum: @list
            }
          }
        end

        def xml_formatted_properties
          <<-XML
            <parameter>
              <name>#{@name}</name>
              <type>string</type>
              <description>#{@description}</description>
              <enum>#{@list}</enum>
              <required>true</required>
            </parameter>
          XML
        end
      end
    end
  end
end
