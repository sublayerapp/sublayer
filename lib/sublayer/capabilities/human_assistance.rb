require "tempfile"

module Sublayer
  module Capabilities
    module HumanAssistance
      def human_assistance_with(string_to_assist_with)
        tempfile = Tempfile.new("some_tempfile_to_assist_with")
        tempfile.write(string_to_assist_with)
        tempfile.close

        system("$EDITOR #{tempfile.path}")

        tempfile.open
        results = tempfile.read

        tempfile.close
        tempfile.unlink

        results.chomp
      end
    end
  end
end
