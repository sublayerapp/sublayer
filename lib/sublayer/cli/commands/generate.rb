require_relative "./generator"

module Sublayer
  module Commands
    class Generate < SubCommandBase

      register(Sublayer::Commands::Generator, "generator", "generator DESCRIPTION", "Generates a new generator")

    end
  end
end
