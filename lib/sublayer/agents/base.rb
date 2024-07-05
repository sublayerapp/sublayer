module Sublayer
  module Agents
    class Base
      class << self
        attr_reader :triggers, :goal_condition_block, :check_status_block, :step_block, :listeners

        def trigger(trigger_instance = nil)
          @triggers ||= []

          if trigger_instance
            @triggers << trigger_instance
          else
            raise ArgumentError, "Either a trigger instance or a block must be provided"
          end
        end

        def trigger_on_files_changed(&block)
          trigger(Triggers::FileChange.new(&block))
        end

        def goal_condition(&block)
          @goal_condition_block = block
        end

        def check_status(&block)
          @check_status_block = block
        end

        def step(&block)
          @step_block = block
        end
      end

      def run
        setup_triggers
        take_step
        sleep
      end

      private

      def setup_triggers
        @listeners = []

        self.class.triggers.each do |trigger|
          listener = trigger.setup(self)
          @listeners << listener if listener
        end
      end

      def take_step
        instance_eval(&self.class.check_status_block)
        instance_eval(&self.class.step_block) unless instance_eval(&self.class.goal_condition_block)
      end
    end
  end
end
