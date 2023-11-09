# Sublayer

An AI agent framework

## Installation

Install the gem by running the following commands:

    $ bundle
    $ gem build sublayer.gemspec
    $ gem install sublayer-0.0.1.gem

Your OpenAI API key needs to be accessible in your environment at OPENAI\_API\_KEY

Your default editor for your environment is also used.

## Usage

* Interactive CLI
You can use the gem by running the command `sublayer` in any project directory.
This will open an interactive shell where all file operations are run relative
to that root project directory.

In the interactive shell, you're able to create new agents specific to your
project, generate code, modify existing files, and save the resulting code from
those agent commands.

* Simple TDD Pair (experimental / dangerous)
**Warning:** This will generate code from GPT4 and run it as called from your
tests. Use at your own risk.

Usage: `sublayer_simple_tdd_pair "TEST_RUN_COMMAND" "FILE_UNDER_TEST"`

This command will run the TEST_RUN_COMMAND, send the test output, the tests, and
the FILE\_UNDER\_TEST to GPT4 and will attempt to edit FILE\_UNDER\_TEST and
rerun the tests until they pass.

To do use it like in [this
loom] (https://www.loom.com/share/6970b51856b04a91b792f14e848e9b6d) you'll need
to install entr: `brew install entr`

The command I'm running there is: `ls ./day3/*.rb | entr sublayer_simple_tdd_pair "rspec ./day3/santa_spec.rb" "./day3/santa.rb"`

## Development

TBD

## Contributing

TBD
