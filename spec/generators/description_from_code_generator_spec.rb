require "spec_helper"

require "generators/examples/description_from_code_generator"

RSpec.describe DescriptionFromCodeGenerator do
  def generate(code)
    described_class.new(code: code).generate
  end

  context "Claude" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
      Sublayer.configuration.ai_model = "claude-3-haiku-20240307"
    end

    it "generates description from hello world code" do
      VCR.use_cassette("claude/generators/description_from_code_generator/hello_world") do
        code = %q(#!/usr/bin/env ruby

        require 'optparse'

        options = {}
        OptionParser.new do |opts|
          opts.banner = "Usage: hello.rb [options]"

          opts.on("-w", "--who PERSON", "Name of the person to greet") do |person|
            options[:who] = person
          end
        end.parse!

        who = options[:who] || "world"
        puts "Hello, #{who}!")

        description = generate(code).strip.downcase
        expect(description).to include('ruby script')
        expect(description).to include('optparse')
        expect(description).to include('--who')
        expect(description).to include('default')
        expect(description).to include('world')
      end
    end
  end

  context "OpenAI" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
      Sublayer.configuration.ai_model = "gpt-4-turbo"
    end

    it "generates description from hello world code" do
      VCR.use_cassette("openai/generators/description_from_code_generator/hello_world") do
        code = %q(#!/usr/bin/env ruby

        require 'optparse'

        options = {}
        OptionParser.new do |opts|
          opts.banner = "Usage: hello.rb [options]"

          opts.on("-w", "--who PERSON", "Name of the person to greet") do |person|
            options[:who] = person
          end
        end.parse!

        who = options[:who] || "world"
        puts "Hello, #{who}!")

        description = generate(code)
        expect(description.strip).to eq <<~DESCRIPTION.strip
        The provided Ruby script is a simple command-line application that greets a user. It starts by including the option parser library, then sets up command-line options allowing the user to specify a name with the '-w' or '--who' switch. In absence of this switch, it defaults to greeting 'world'. Finally, it outputs a greeting message to the terminal, addressing either the specified name or 'world' if no name was given.
        DESCRIPTION
      end
    end
  end

  context "Gemini" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
      Sublayer.configuration.ai_model = "gemini-1.5-pro-latest"
    end

    it "generates description from hello world code" do
      VCR.use_cassette("gemini/generators/description_from_code_generator/hello_world") do
        code = %q(#!/usr/bin/env ruby

        require 'optparse'

        options = {}
        OptionParser.new do |opts|
          opts.banner = "Usage: hello.rb [options]"

          opts.on("-w", "--who PERSON", "Name of the person to greet") do |person|
            options[:who] = person
          end
        end.parse!

        who = options[:who] || "world"
        puts "Hello, #{who}!")

        description = generate(code)
        expect(description.strip).to eq <<~DESCRIPTION.strip
        This Ruby code is a simple command-line program that greets a person by name. \\n\\nHere is a breakdown of the code:\\n\\n1. **Requires the `optparse` library:** This line includes the `optparse` library, which is used for parsing command-line options.\\n2. **Initializes an options hash:** `options = {}` creates an empty hash called `options` to store command-line arguments.\\n3. **Defines command-line options:**\\n   - `OptionParser.new do |opts| ... end.parse!` creates a new OptionParser object and defines the command-line options.\\n   - `opts.banner = \"Usage: hello.rb [options]\"` sets the banner message displayed at the top of the help text.\\n   - `opts.on(\"-w\", \"--who PERSON\", \"Name of the person to greet\") do |person| ... end` defines an option `-w` or `--who` that takes a `PERSON` argument. The value of the argument is stored in the `options[:who]` hash.\\n4. **Gets the name to greet:**\\n   - `who = options[:who] || \"world\"` retrieves the value of the `:who` option from the `options` hash. If the option is not provided, it defaults to \"world\".\\n5. **Prints the greeting:**\\n   - `puts \"Hello, \#{who}!\"` prints the greeting message with the name of the person being greeted.
        DESCRIPTION
      end
    end

  end
end
