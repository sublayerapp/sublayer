module Sublayer
  module Logging
    class Base
      def log(level, message, data = {})
        raise NotImplementedError, "Subclasses must implement log method"
      end
    end
  end
end
