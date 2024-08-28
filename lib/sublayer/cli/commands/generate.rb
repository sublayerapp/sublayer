require_relative "./generator"

module Sublayer
  module Commands
    class Generate < SubCommandBase
      register(Sublayer::Commands::Generator, "generator", "generator", "Generates a new Sublayer::Generator subclass for your project")
    end
  end
end
