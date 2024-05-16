module Sublayer
  module Agents
    class Base
      class << self
        attr_accessor :goal_condition_block, :trigger_condition_block, :trigger_on_files_changed_block, :check_status_block, :step_block

        def trigger_condition(&block)
          self.trigger_condition_block = block
        end

        def trigger_on_files_changed(&block)
          self.trigger_on_files_changed_block = block
        end

        def goal_condition(&block)
          self.goal_condition_block = block
        end

        def check_status(&block)
          self.check_status_block = block
        end

        def step(&block)
          self.step_block = block
        end
      end

      def run
        files_to_listen_to = instance_eval(&self.class.trigger_on_files_changed_block).map { |file| File.expand_path(file) }
        folders = files_to_listen_to.map { |file| File.dirname(file) }.uniq

        listener = Listen.to(*folders) do |modified, added, removed|
          if files_to_listen_to.any? { |file| modified.include?(file) }
            take_step
          end
        end

        listener.start

        take_step

        sleep
      end

      private

      def take_step
        instance_eval(&self.class.check_status_block)
        instance_eval(&self.class.step_block) unless instance_eval(&self.class.goal_condition_block)
      end
    end
  end
end
