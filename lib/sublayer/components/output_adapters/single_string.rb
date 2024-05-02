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

        def format(value)
          value
        end
      end
    end
  end
end
