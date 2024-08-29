require_relative "./generators/sublayer_agent_generator"

module Sublayer
  module Commands
    class Agent < Thor::Group
      include Thor::Actions

      class_option :description, type: :string, desc: "Description of the agent you want to generate", aliases: :d
      class_option :provider, type: :string, desc: "AI provider (OpenAI, Claude, or Gemini)", aliases: :p
      class_option :model, type: :string, desc: "AI model name to use (e.g. gpt-4o, claude-3-haiku-20240307, gemini-1.5-flash-latest)", aliases: :m

      def confirm_usage_of_ai_api
        puts "You are about to generate a new agent that uses an AI API to generate content."
        puts "Please ensure you have the necessary API keys and that you are aware of the costs associated with using the API."
        exit unless yes?("Do you want to continue?")
      end

      def determine_available_providers
        @available_providers = []

        @available_providers << "OpenAI" if ENV["OPENAI_API_KEY"]
        @available_providers << "Claude" if ENV["ANTHROPIC_API_KEY"]
        @available_providers << "Gemini" if ENV["GEMINI_API_KEY"]
      end

      def ask_for_agent_details
        @ai_provider = options[:provider] || ask("Select an AI provider:", default: "OpenAI", limited_to: @available_providers)
        @ai_model = options[:model] || select_ai_model
        @description = options[:description] || ask("Enter a description for the Sublayer Agent you'd like to create:")
        @trigger = ask("What should trigger this agent to start acting?")
        @goal = ask("What is the agent's goal condition?")
        @check_status = ask("How should the agent check its status toward the goal?")
        @step = ask("How does the agent take a step toward its goal?")
      end

      def generate_agent
        Sublayer.configuration.ai_provider = Object.const_get("Sublayer::Providers::#{@ai_provider}")
        Sublayer.configuration.ai_model = @ai_model

        say "Generating Sublayer Agent..."

        @results = SublayerAgentGenerator.new(
          description: @description,
          trigger: @trigger_explanation,
          goal: @goal,
          check_status: @check_status,
          step: @step
        ).generate
      end

      def determine_destination_folder
        @destination_folder = if File.directory?("./agents")
                                "./agents"
                              elsif Dir.glob("./lib/**/agents").any?
                                Dir.glob("./lib/**/agents").first
                              else
                                "./"
                              end
      end

      def save_agent_to_destination_folder
        create_file File.join(@destination_folder, @results.filename), @results.code
      end

      private

      def select_ai_model
        case @ai_provider
        when "OpenAI"
          ask("Which OpenAI model would you like to use?", default: "gpt-4o")
        when "Claude"
          ask("Which Anthropic model would you like to use?", default: "claude-3-5-sonnet-20240620")
        when "Gemini"
          ask("Which Google model would you like to use?", default: "gemini-1.5-flash-latest")
        end
      end
    end
  end
end
