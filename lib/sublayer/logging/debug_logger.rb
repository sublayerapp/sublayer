module Sublayer
  module Logging
    class DebugLogger < Base
      def log(level, message, data = {})
        puts "[#{Time.now.iso8601}] #{level.upcase}: #{message}"
        pp data unless data.empty?
      end
    end
  end
end
