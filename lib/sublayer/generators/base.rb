module Sublayer
  module Generators
    class Base
      attr_reader :results

      def self.llm_output_adapter(options)
        output_adapter = Sublayer::Components::OutputAdapters.create(options)
        const_set(:OUTPUT_ADAPTER, output_adapter)
      end

      def generate
        @results = Sublayer.configuration.ai_provider.call(
          prompt: prompt,
          output_adapter: self.class::OUTPUT_ADAPTER,
          images: images
        )
      end

      private

      def images
        []
      end
    end
  end
end
