# Sublayer

A model-agnostic Ruby AI Agent framework. Provides base classes for
building Generators, Actions, Tasks, and Agents that can be used to build AI
powered applications in Ruby.

For more detailed documentation visit our documentation site: [https://docs.sublayer.com](https://docs.sublayer.com).

## Installation

Install the gem by running the following commands:

    $ gem install sublayer

Or add this line to your application's Gemfile:

```ruby
gem 'sublayer'
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

### Groq

Expects you to have a Groq API key set in the `GROQ_API_KEY` environment variable.

Visit [Groq Console](https://console.groq.com/) to get an API key.

Usage:
```ruby
Sublayer.configuration.ai_provider = Sublayer::Providers::Groq
Sublayer.configuration.ai_model = "mixtral-8x7b-32768"
```

### Local

If you've never run a local model before see the [Local Model Quickstart](#local-model-quickstart) below. Know that local models take several GB of space.

The model you use must have the ChatML formatted v1/chat/completions endpoint to work with sublayer (many models do by default)

Usage:

Run your local model on http://localhost:8080 and then set:
```ruby
Sublayer.configuration.ai_provider = Sublayer::Providers::Local
Sublayer.configuration.ai_model = "LLaMA_CPP"
```

#### Local Model Quickstart:

Instructions to run a local model

1. Setting up Llamafile

  ```bash
  cd where/you/keep/your/projects
  git clone git@github.com:Mozilla-Ocho/llamafile.git
  cd llamafile
  ```

  Download: https://cosmo.zip/pub/cosmos/bin/make (windows users need this too: https://justine.lol/cosmo3/)

  ```bash
  # within llamafile directory
  chmod +x path/to/the/downloaded/make
  path/to/the/downloaded/make -j8
  sudo path/to/the/downloaded/make install PREFIX=/usr/local
  ```
  You can now run llamfile

2. Downloading Model

  click [here](https://huggingface.co/NousResearch/Hermes-2-Pro-Mistral-7B-GGUF/resolve/main/Hermes-2-Pro-Mistral-7B.Q5_K_M.gguf?download=true) to download Mistral_7b.Q5_K_M (5.13 GB)

3. Running Llamafile with a model

  ```bash
  llamafile -ngl 9999 -m path/to/the/downloaded/Hermes-2-Pro-Mistral-7B.Q5_K_M.gguf --host 0.0.0.0 -c 4096
  ```

  You are now running a local model on http://localhost:8080

#### Recommended Settings for Apple M1 users:
```bash
llamafile -ngl 9999 -m Hermes-2-Pro-Mistral-7B.Q5_K_M.gguf --host 0.0.0.0 --nobrowser -c 2048 --gpu APPLE -t 12
```
run `sysctl -n hw.logicalcpu` to see what number to give the `-t` threads option

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

## Development

TBD

## Contributing

TBD
