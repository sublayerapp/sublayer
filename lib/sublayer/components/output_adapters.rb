module Sublayer
  module Components
    module OutputAdapters
      attr_reader :name

      def self.create(options)
        klass = if options.has_key?(:class)
          klass = options[:class]
          if klass.is_a?(String)
            klass.constantize
          elsif klass.is_a?(Class)
            klass
          else
            raise "Invalid :class option"
          end
        elsif (type = options[:type])
          "Sublayer::Components::OutputAdapters::#{type.to_s.camelize}".constantize
        else
          raise "Output adapter must be specified with :class or :type"
        end
        klass.new(options)
      end
    end
  end
end
