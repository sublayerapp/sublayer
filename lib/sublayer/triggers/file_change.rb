module Sublayer
  module Triggers
    class FileChange < Base
      def initialize(&block)
        @block = block
      end

      def setup(agent)
        files_to_watch = agent.instance_eval(&@block)
        folders = files_to_watch.map { |file| File.dirname(File.expand_path(file)) }.uniq

        Listen.to(*folders) do |modified, added, removed|
          if files_to_watch.any? { |file| modified.include?(File.expand_path(file)) }
            activate(agent)
          end
        end.start
      end
    end
  end
end
