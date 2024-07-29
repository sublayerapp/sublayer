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
      end
    end
  end
end
