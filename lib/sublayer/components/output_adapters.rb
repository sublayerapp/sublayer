module Sublayer
  module Components
    module OutputAdapters
      attr_reader :name

      def self.create(options)
        ("Sublayer::Components::OutputAdapters::"+options[:type].to_s.camelize).constantize.new(options)
      end
    end
  end
end
