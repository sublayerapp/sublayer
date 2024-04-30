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
version 0.1.x, you would add the following line to your Gemfile:

```ruby
gem 'sublayer', '~> 0.1'
```

## Installation

Install the gem by running the following commands:

    $ gem install sublayer

Or add this line to your application's Gemfile:

```ruby
gem 'sublayer', '~> 0.1'
```

## Choose your AI Model

Sublayer is model-agnostic and can be used with any AI model. Below are the

### OpenAI (Default)

Expects you to have an OpenAI API key set in the `OPENAI_API_KEY` environment variable.

Visit [OpenAI](https://openai.com/product) to get an API key.

Usage:
```ruby
Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
Sublayer.configuration.ai_model = "gpt-4-turbo-preview"
```

### Gemini

Expects you to have a Gemini API key set in the `GEMINI_API_KEY` environment variable.

Visit [Google AI Studio](https://ai.google.dev/) to get an API key.

Usage:
```ruby
Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
Sublayer.configuration.ai_model = "gemini-pro"
```

### Claude

Expect you to have a Claude API key set in the `ANTHROPIC_API_KEY` environment variable.

Visit [Anthropic](https://anthropic.com/) to get an API key.


Usage:
```ruby
Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
Sublayer.configuration.ai_model ="claude-3-opus-20240229"
```

## Concepts

### Generators

Generators are responsible for generating specific outputs based on input data.
They focus on a single generation task and do not perform any actions or complex
decision-making. Generators are the building blocks of the Sublayer framework.

Examples (in the `/lib/sublayer/generators/examples` directory):
- `CodeFromDescriptionGenerator`: Generates code based on a description and the
  technologies used.
- `DescriptionFromCodeGenerator`: Generates a description of the code passed in to
  it.
- `CodeFromBlueprintGenerator`: Generates code based on a blueprint, a blueprint
  description, and a description of the desired code.


### Actions (Coming Soon)

Actions are responsible for performing specific operations to get inputs for a
Generator or based on the generated output from a Generator. They encapsulate a
single action and do not involve complex decision-making. Actions are  the
executable units that bring the generated inputs to life.

Examples:
- SaveToFileAction: Saves generated output to a file.
- RunCommandLineCommandAction: Runs a generated command line command.

### Tasks (Coming Soon)

Tasks combine Generators and Actions to accomplish a specific goal. They involve
a sequence of generation and action steps that may include basic decision-making
and flow control. Tasks are the high-level building blocks that define the
desired outcome.

Examples:
- ModifyFileContentsTask: Generates new file contents based on the existing
  contents and a set of rules, and then saves the new contents to the file.

### Agents (Coming Soon)

Agents are high-level entities that coordinate and orchestrate multiple Tasks to
achieve a broader goal. They involve complex decision-making, monitoring, and
adaptation based on the outcomes of the Tasks. Agents are the intelligent
supervisors that manage the overall workflow.

Examples:
- CustomerSupportAgent: Handles customer support inquiries by using various
  Tasks such as understanding the customer's issue, generating appropriate
responses, and performing actions like sending emails or creating support
tickets.

## Usage Examples

There are sample Generators in the /examples/ directory that demonstrate how to
build generators using the Sublayer framework. Alternatively below are links to
open source projects that are using generators in different ways:

- [Blueprints](https://blueprints.sublayer.com) - An open source AI code
  assistant that allows you to capture patterns in your codebase to use as a
base for generating new code.

- [Clag](https://github.com/sublayerapp/clag) - A ruby gem that generates
  command line commands from a simple description right in your terminal.
