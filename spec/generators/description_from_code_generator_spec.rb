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

        description = generate(code)

        expect(description).to be_a(String)
        expect(description.length).to be > 0
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
        expect(description).to be_a(String)
        expect(description.length).to be > 0
      end
    end
  end
end
