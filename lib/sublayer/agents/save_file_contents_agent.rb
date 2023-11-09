module Sublayer
  module Agents
    class SaveFileContentsAgent
      attr_reader :file_contents, :file_path

      def initialize(file_contents:, file_path:)
        @file_contents = file_contents
        @file_path = file_path
      end

      def execute
        File.open(file_path, "w") do |file|
          file.write(file_contents)
        end
      end
    end
  end
end
