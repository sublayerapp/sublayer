module Sublayer
  module Logging
    class NullLogger < Base
      def log(level, message, data = {})
        # do nothing
      end
    end
  end
end
