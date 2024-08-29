class SublayerGeneratorGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :named_strings,
    name: "sublayer_generator",
    description: "The new Sublayer generator code based on the description",
    attributes: [
      { name: "code", description: "The code of the generated Sublayer generator" },
      { name: "filename", description: "The filename of the generated Sublayer generator snake cased and with a .rb extension" }
    ]

  def initialize(description:)
    @description = description
  end

  def generate
    super
  end

  def prompt
    <<-PROMPT
    You are an expert ruby programmer and and great at repurposing code examples to use for new situations.

    A Sublayer generator is a class that acts as an abstraction for sending a request to an LLM and getting structured data back.

    An example Sublayer generator is:
    <example_generator>
    #{example_generator}
    </example_generator>

    And it is the generator we're currently using for taking in a description from a user and generating a new Sublayer generator.

    All Sublayer::Generators inherit from Sublayer::Generators::Base and have a generate method that simply calls super for the user to use and modify for their uses.

    the llm_output_adapter directive is used to instruct the LLM on what structure of output to generate. In the example we're using type: :single_string which takes a name and description as arguments.

    the other available options and their example usage is:
    llm_output_adapter type: :list_of_strings,
      name: "suggestions",
      description: "List of keyword suggestions"

    llm_output_adapter type: :single_integer,
      name: "four_digit_passcode",
      description: "an uncommon and difficult to guess four digit passcode"

    llm_output_adapter type: :list_of_named_strings,
      name: "review_summaries",
      description: "List of movie reviews",
      item_name: "review",
      attributes: [
        { name: "movie_title", description: "The title of the movie" },
        { name: "reviewer_name", description: "The name of the reviewer" },
        { name: "rating", description: "The rating given by the reviewer (out of 5 stars)" },
        { name: "brief_comment", description: "A brief summary of the movie" }
      ]

    llm_output_adapter type: :named_strings,
      name: "product_description",
      description: "Generate product descriptions",
      attributes: [
        { name: "short_description", description: "A brief one-sentence description of the product" },
        { name: "long_description", description: "A detailed paragraph describing the product" },
        { name: "key_features", description: "A comma-separated list of key product features" },
        { name: "target_audience", description: "A brief description of the target audience for this product" }
      ]

    # Where :available_routes is a method that returns an array of available routes
    llm_output_adapter type: :string_selection_from_list,
      name: "route",
      description: "A route selected from the list",
      options: :available_routes

    # Where @sentiment_options is an array of sentiment values passed in to the initializer
    llm_output_adapter type: :string_selection_from_list,
      name: "sentiment_value",
      description: "A sentiment value from the list",
      options: -> { @sentiment_options }

    Besides that, a Sublayer::Generator also has a prompt method that describes the task to the LLM and provides any necessary context for the generation which
    is either passed in through the initializer or accessed in the prompt itself.

    You have a description provided by the user to generate a new sublayer generator.

    You are tasked with creating a new sublayer generator according to the given description.

    Consider the details and requirements mentioned in the description to create the appropriate Sublayer::Generator.
    <users_description>
    #{@description}
    </users_description>

    Take a deep breath and reflect on each aspect of the description before proceeding with the generation.
    PROMPT
  end

  def example_generator
    File.read(File.join(File.dirname(__FILE__), "example_generator.rb"))
  end
end
