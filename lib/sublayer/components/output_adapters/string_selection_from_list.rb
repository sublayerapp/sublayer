module Sublayer
  module Components
    module OutputAdapters
      class StringSelectionFromList
        attr_reader :name, :description, :options

        def initialize(options)
          @name = options[:name]
          @description = options[:description]
          @list = options[:options]
        end

        def properties
          [OpenStruct.new(name: @name, type: 'string', description: @description, required: true, enum: @list)]
        end
      end
    end
  end
end
