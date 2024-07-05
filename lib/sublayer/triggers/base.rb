module Sublayer
  module Triggers
    class Base
      def setup(agent)
        raise NotImplementedError, "Subclasses must implement setup method"
      end

      def activate(agent)
        agent.send(:take_step)
      end
    end
  end
end
