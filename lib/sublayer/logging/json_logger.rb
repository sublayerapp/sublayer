module Sublayer
  module Logging
    class JsonLogger < Base
      def initialize(log_file = "./tmp/sublayer.log")
        @log_file = log_file
      end

      def log(level, message, data = {})
        File.open(@log_file, "a") do |f|
          f.puts JSON.generate({
            timestamp: Time.now.iso8601,
            level: level,
            message: message,
            data: data
          })
        end
      end
    end
  end
end
