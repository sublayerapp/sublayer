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

        def to_xml
          <<-XML
            <tool_description>
              <tool_name>#{@name}</tool_name>
              <tool_description>#{@description}</tool_description>
              <parameters>
                <name>#{@name}</name>
                <type>string</type>
                <description>#{@description}</description>
              </parameters>
            </tool_description>
          XML
        end
      end
    end
  end
end
