module Sublayer
  module Components
    module OutputAdapters
      class SingleString < Base
        attr_reader :name, :description

        def initialize(options)
          @name = options[:name]
          @description = options[:description]
        end

        def properties
          [OpenStruct.new(name: @name, type: 'string', description: @description, required: true)]
        end
      end
    end
  end
end
