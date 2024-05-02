module Sublayer
  module Components
    module OutputAdapters
      class Integer
        attr_reader :name, :description

        def initialize(options)
          @name = options[:name]
          @description = options[:description]
        end

        def properties
          [OpenStruct.new(name: @name, type: 'integer', description: @description, required: true)]
        end

        def format(value)
          value.to_i
        end
      end
    end
  end
end
