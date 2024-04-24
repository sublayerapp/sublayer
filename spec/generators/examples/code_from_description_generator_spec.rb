require "pry"
require "spec_helper"

require "sublayer/generators/examples/code_from_description_generator"

RSpec.describe CodeFromDescriptionGenerator do
  def generate(description:, technologies: ["ruby"])
    described_class.new(
      description: description,
      technologies: technologies
    ).generate
  end

  context "claude" do
    before do
      Sublayer.configuration.ai_provider = Sublayer::Providers::Claude
      Sublayer.configuration.ai_model = "claude-3-haiku-20240307"
    end

    it "generates code from description" do
      VCR.use_cassette("claude/generators/code_from_description_generator/hello_world") do
        code = generate(description: "a hello world app where I pass --who argument to set the 'world' value using optparser")
        expect(code.strip).to eq %q(#!/usr/bin/env ruby

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
      end
    end

    context "openai" do
      before do
        Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
        Sublayer.configuration.ai_model = "gpt-4-turbo"
      end

      it "generates code from description" do
        VCR.use_cassette("openai/generators/code_from_description_generator/hello_world") do
          code = generate(description: "a hello world app where I pass --who argument to set the 'world' value using optparser")
          expect(code.strip).to eq %q(require 'optparse'

# Define the options
options = {}
OptionParser.new do |parser|
  parser.banner = "Usage: example.rb [options]"

  parser.on("-w", "--who WHO", "Who to greet") do |v|
    options[:who] = v
  end
end.parse!

# Greeting
who_to_greet = options[:who] || "World"
puts "Hello, #{who_to_greet}!")
        end
      end

    end
  end
end
