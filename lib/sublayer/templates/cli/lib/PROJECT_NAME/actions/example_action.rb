# frozen_string_literal: true

module ProjectName
  module Actions
    class ExampleAction < Sublayer::Actions::Base
      def initialize(input:)
        @input = input
      end

      def call
        puts "Performing action with input: #{@input}"
      end
    end
  end
end
