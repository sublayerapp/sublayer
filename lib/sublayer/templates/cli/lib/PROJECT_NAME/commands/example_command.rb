module ProjectName
  module Commands
    class ExampleCommand < BaseCommand
      def self.description
        "An example command that generates a story based on the command line arguments."
      end

      def execute(*args)
        puts ProjectName::Generators::ExampleGenerator.new(input: args.join(" ")).generate
      end
    end
  end
end
