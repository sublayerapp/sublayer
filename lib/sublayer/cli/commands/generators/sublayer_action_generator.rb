class SublayerActionGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :named_strings,
    name: "sublayer_action",
    description: "The new sublayer action based on the description and supporting information",
    attributes: [
      { name: "code", description: "The code of the generated Sublayer action" },
      { name: "filename", description: "The filename of the generated sublayer action snake cased with a .rb extension" }
    ]

  def initialize(description:)
    @description = description
  end

  def generate
    super
  end

  def prompt
    <<-PROMPT
    You are an expert ruby programmer and are great at repurposing code examples to use for new situations.

    A Sublayer Action is an example of a command pattern that is used in the Sublayer AI framework to perform actions in the outside world such as manipulating files or making API calls.

    The Sublayer framework also has a component called a Generator that takes data in, sends it to an LLM and gets structured data out.
    Sublayer::Actions are used both to retrieve data for use in a generator or perform actions based on the output of the generator.
    This is used to both aid in generating new composable bits of functionality and to ease testing.

    A sublayer action is initialized with the data it needs and then exposes a `call` method which is used to perform the action.

    An example of an action being used to save a file to the file system, for example after generating the contents is:
    <example_file_manipulation_action>
    #{example_filesystem_action}
    </example_file_manipulation_action>

    An example action being used to make a call to an external api, such as OpenAI's text to speech API is:
    <example_api_call_action>
    #{example_api_action}
    </example_api_call_action>

    Your task is to generate a new Sublayer::Action::Base subclass that performs an action based on the description provided.
    <description>
    #{@description}
    </description>
    PROMPT
  end

  private
  def example_filesystem_action
    File.read(File.join(File.dirname(__FILE__), 'example_action_file_manipulation.rb'))
  end

  def example_api_action
    File.read(File.join(File.dirname(__FILE__), 'example_action_api_call.rb'))
  end
end
