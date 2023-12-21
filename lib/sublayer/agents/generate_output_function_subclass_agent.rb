module Sublayer
  module Agents
    class GenerateOutputFunctionSubclassAgent
      include Sublayer::Capabilities::LLMAssistance
      include Sublayer::Capabilities::HumanAssistance

      attr_reader :description, :results

      llm_result_format type: :single_string,
        name: "generated_output_function_subclass",
        description: "The ruby code for the generated output function subclass"

      def initialize(description:)
        @description = description
      end

      def execute
        @results = human_assistance_with(llm_generate)
      end

      def prompt
        <<-PROMPT
        You are an expert programmer in Ruby and at building Output Function subclasses.

        An output function subclass takes any required options it needs to generate the output and implements a to_hash class that follows the OpenAPI to convert the options into the specified format.

        An example OutputFunction subclass can be found here: #{File.read(File.expand_path(__dir__ + "/../components/output_function_formats/single_string.rb"))} this one named SingleString takes a name of a single string parameter and a description of that parameter and formats it into the OpenAPI spec. It is called like this:
      llm_result_format type: :single_string,
        name: "generated_sublayer_agent",
        description: "The ruby code for the sublayer agent"

        Another example OutputFunction subclass can be found here: #{File.read(File.expand_path(__dir__ + "/../components/output_function_formats/list_of_objects.rb"))} this one named ListOfObjects takes a list of objects and a description of those objects and formats it into the OpenAPI spec. It is called like this:
        llm_result_format type: :list_of_objects,
          name: "retrieved_steps",
          description: "The retrieved steps for performing the given coding task",
          structure: {
            category: "The category of the step",
            command: "The command to run on the command line",
            description: "The description of what the command is for"
          }

        The type is a symbol that should map directly to the name of the OutputFunction subclass.

        You need to create a new subclass that takes the following options and formats them into the OpenAPI spec:
        #{description}

        Take a deep breath and think step by step before you start coding.
        PROMPT
      end

    end
  end
end
