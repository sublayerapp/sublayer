module ProjectName
  module Commands
    class ExampleCommand < BaseCommand
      def self.description
        "This is an example command"
      end

      def execute(*args)
        puts "Executing example command with args: #{args.join(', ')}"
      end
    end
  end
end
