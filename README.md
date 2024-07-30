# Sublayer

A model-agnostic Ruby AI Agent framework. Provides base classes for
building Generators, Actions, Tasks, and Agents that can be used to build AI
powered applications in Ruby.

For more detailed documentation visit our documentation site: [https://docs.sublayer.com](https://docs.sublayer.com).

## Note on Versioning

Pre-1.0 we anticipate many breaking changes to the API. Our current plan is to
keep breaking changes to minor, 0.x releases, and patch releases (0.x.y) will be used
for new features and bug fixes.

To maintain stability in your application, we recommend pinning the version of
Sublayer in your Gemfile to a specific minor version. For example, to pin to
version 0.2.x, you would add the following line to your Gemfile:

```ruby
gem 'sublayer', '~> 0.2'
```

## Notes on 0.2

New default model update: gpt 4 turbo -> gpt 4o

Gemini: Updates include the use of beta API function calling features. Experimental and unstable.

## Installation

Install the gem by running the following commands:

    $ gem install sublayer

Or add this line to your application's Gemfile:

```ruby
gem 'sublayer', '~> 0.2'
```

## Choose your AI Model

Sublayer is model-agnostic and can be used with any AI model. Below are the supported LLM Providers. Check out our [docs](https://docs.sublayer.com) to add your own custom Provider.

### OpenAI (Default)

Expects you to have an OpenAI API key set in the `OPENAI_API_KEY` environment variable.

Visit [OpenAI](https://openai.com/product) to get an API key.

Usage:
```ruby
Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
Sublayer.configuration.ai_model = "gpt-4o"
```

### Gemini [UNSTABLE]

(Gemini's function calling API is in beta. Not recommended for production use.)

Expects you to have a Gemini API key set in the `GEMINI_API_KEY` environment variable.

Visit [Google AI Studio](https://ai.google.dev/) to get an API key.

Usage:
```ruby
Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
Sublayer.configuration.ai_model = "gemini-1.5-pro"
```

### Claude

Expect you to have a Claude API key set in the `ANTHROPIC_API_KEY` environment variable.

Visit [Anthropic](https://anthropic.com/) to get an API key.


Usage:
```ruby
Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
Sublayer.configuration.ai_model ="claude-3-5-sonnet-20240620"
```

## Concepts

### Generators

Generators are responsible for generating specific outputs based on input data.
They focus on a single generation task and do not perform any actions or complex
decision-making. Generators are the building blocks of the Sublayer framework.

Examples (in the `/spec/generators/examples` directory):
- [CodeFromDescriptionGenerator](https://github.com/sublayerapp/sublayer/blob/main/spec/generators/examples/code_from_description_generator.rb):
  Generates code based on a description and the technologies used.
- [DescriptionFromCodeGenerator](https://github.com/sublayerapp/sublayer/blob/main/spec/generators/description_from_code_generator_spec.rb):
  Generates a description of the code passed in to it.
- [CodeFromBlueprintGenerator](https://github.com/sublayerapp/sublayer/blob/main/spec/generators/examples/code_from_blueprint_generator.rb):
  Generates code based on a blueprint, a blueprint description, and a description of the desired code.


### Actions

Actions perform specific operations to either get inputs for a Generator or use
the generated output from a Generator. Actions do not involve complex decision making.

Examples:
- [WriteFileAction](https://github.com/sublayerapp/tddbot/blob/43297c5da9445bd6c8882d5e3876cff5fc6b2650/lib/tddbot/sublayer/actions/write_file_action.rb):
  Saves generated output to a file.
- [RunTestCommandAction](https://github.com/sublayerapp/tddbot/blob/43297c5da9445bd6c8882d5e3876cff5fc6b2650/lib/tddbot/sublayer/actions/run_test_command_action.rb):
  Runs a generated command line command.

### Agents

Sublayer Agents are autonomous entities designed to perform specific
tasks or monitor systems.

Examples:
- [RSpecAgent](https://github.com/sublayerapp/sublayer/blob/main/spec/agents/examples/rspec_agent.rb):
  Runs tests whenever a file is changed. If the tests fail the code is changed
  by the agent to pass the tests.

### Triggers

Sublayer Triggers are used in agents. Triggers decide when an agent is activated
and performs its task

Examples:
- [FileChange](https://github.com/sublayerapp/sublayer/blob/main/lib/sublayer/triggers/file_change.rb):
  This built in sublayer trigger, listens for file changes
- [TimeInterval](https://docs.sublayer.com/docs/guides/build-a-custom-trigger)
  This custom trigger tutorial shows how to create your own trigger, this one activates on a time interval

## Usage Examples

There are sample Generators in the /examples/ directory that demonstrate how to
build generators using the Sublayer framework. Alternatively below are links to
open source projects that are using generators in different ways:

- [Blueprints](https://blueprints.sublayer.com) - An open source AI code
  assistant that allows you to capture patterns in your codebase to use as a
base for generating new code.

- [Clag](https://github.com/sublayerapp/clag) - A ruby gem that generates
  command line commands from a simple description right in your terminal.
