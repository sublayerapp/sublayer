module Sublayer
  module Generators
    class Base
      attr_reader :results

      def self.llm_output_adapter(options)
        output_adapter = Sublayer::Components::OutputAdapters.create(options).extend(Sublayer::Components::OutputAdapters::Formattable)
        const_set(:OUTPUT_ADAPTER, output_adapter)
      end

      def generate
        self.class::OUTPUT_ADAPTER.load_instance_data(self) if self.class::OUTPUT_ADAPTER.respond_to?(:load_instance_data)

        raw_results = Sublayer.configuration.ai_provider.call(prompt: prompt, output_adapter: self.class::OUTPUT_ADAPTER)

        @results = self.class::OUTPUT_ADAPTER.respond_to?(:materialize_result) ? self.class::OUTPUT_ADAPTER.materialize_result(raw_results) : raw_results
      end
    end
  end
end
