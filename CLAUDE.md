# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Sublayer is a Ruby gem and CLI framework for building AI-powered applications. It provides base classes for Generators, Actions, Tasks, and Agents that work with multiple AI providers (OpenAI, Claude, Gemini).

## Development Commands

```bash
# Setup
bin/setup                    # Install dependencies and configure dummy API keys
bundle install              # Install gem dependencies

# Testing
rake spec                   # Run RSpec test suite
rake                        # Default task (runs specs)

# Building and releasing
rake build                  # Build gem package
rake install               # Install gem locally
rake release               # Release to RubyGems

# CLI usage (after install)
sublayer new PROJECT_NAME --template=[CLI|GithubAction|QuickScript] --provider=[OpenAI|Claude|Gemini]
sublayer generate:generator  # Generate new Generator class
sublayer generate:agent     # Generate new Agent class
sublayer generate:action    # Generate new Action class
```

## Architecture

The framework is built around four core concepts:

- **Generators** (`lib/sublayer/generators/base.rb`) - Generate specific outputs based on input data
- **Actions** (`lib/sublayer/actions/base.rb`) - Perform operations to get inputs or use generated outputs
- **Agents** (`lib/sublayer/agents/base.rb`) - Autonomous entities with triggers and goal conditions
- **Tasks** (`lib/sublayer/tasks/base.rb`) - Task management components

**AI Provider System**: The framework supports multiple AI providers through a unified interface:
- OpenAI (default: gpt-4o) - `lib/sublayer/providers/open_ai.rb`
- Claude (Anthropic) - `lib/sublayer/providers/claude.rb`
- Gemini (Google, beta) - `lib/sublayer/providers/gemini.rb`

Provider configuration is done via:
```ruby
Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
Sublayer.configuration.ai_model = "claude-3-5-sonnet-20240620"
```

**CLI System**: The CLI (`lib/sublayer/cli/`) includes commands and project templates. Templates generate different project types (CLI apps, GitHub Actions, Quick Scripts) with appropriate scaffolding.

**Trigger System**: Event-based activation system (`lib/sublayer/triggers/`) for file changes and other events.

## Testing

- **Framework**: RSpec with VCR for HTTP request recording/mocking
- **API Keys**: Tests use dummy keys, sensitive data is filtered from VCR cassettes
- **Structure**: Tests organized by component type in `spec/` directory
- **Examples**: Example implementations in `spec/generators/examples/` and `spec/agents/examples/`

## Environment Setup

Required environment variables for AI providers:
```bash
OPENAI_API_KEY=your_key_here
ANTHROPIC_API_KEY=your_key_here  
GEMINI_API_KEY=your_key_here
```

## Key Files

- `lib/sublayer.rb` - Main entry point and configuration
- `bin/sublayer` - CLI executable
- `sublayer.gemspec` - Gem specification
- `lib/sublayer/cli/templates/` - Project scaffolding templates

## Notes

- Framework is pre-1.0 with breaking changes expected in minor releases
- Ruby >= 3.2.0 required
- Gemini provider is marked as unstable/beta