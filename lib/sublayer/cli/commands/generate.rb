require_relative "./generator"
require_relative "./agent"

module Sublayer
  module Commands
    class Generate < SubCommandBase
      register(Sublayer::Commands::Generator, "generator", "generator", "Generates a new Sublayer::Generator subclass for your project")
      register(Sublayer::Commands::Agent, "agent", "agent", "Generates a new Sublayer::Agent subclass for your project")
    end
  end
end
