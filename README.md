# Sublayer

A model-agnostic Ruby Generative AI DSL and framework. Provides base classes for
building Generators, Actions, Tasks, and Agents that can be used to build AI
powered applications in Ruby.

## Installation

Install the gem by running the following commands:

    $ bundle
    $ gem build sublayer.gemspec
    $ gem install sublayer-0.0.1.gem

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

### Groq

Expects you to have a Groq API key set in the `GROQ_API_KEY` environment variable.

Visit [Groq Console](https://console.groq.com/) to get an API key.

Usage:
```ruby
Sublayer.configuration.ai_provider = Sublayer::Providers::Groq
Sublayer.configuration.ai_model = "mixtral-8x7b-32768"
```

### Local

Support for running a local model and serving an API on https://localhost:8080

The simplest way to do this is to download 
[llamafile](https://github.com/Mozilla-Ocho/llamafile) and download one of the
server llamafiles they provide. We've also tested with [this Mixtral
model](https://huggingface.co/NousResearch/Nous-Hermes-2-Mixtral-8x7B-DPO-GGUF) from
[Nous
Research](https://nousresearch.com/).

```ruby
Sublayer.configuration.ai_provider = Sublayer::Providers::Local
Sublayer.configuration.ai_model = "LLaMA_CPP"
```

## Concepts

### Generators

Generators are responsible for generating specific outputs based on input data.
They focus on a single generation task and do not perform any actions or complex
decision-making. Generators are the building blocks of the Sublayer framework.

Examples (in the /examples/ directory):
- CodeFromDescriptionGenerator: Generates code based on a description and the
  technologies used.
- DescriptionFromCodeGenerator: Generates a description of the code passed in to
  it.
- CodeFromBlueprintGenerator: Generates code based on a blueprint, a blueprint
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

## Development

TBD

## Contributing

TBD
