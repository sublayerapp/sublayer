require "pry"
require "spec_helper"

require "generators/examples/code_from_description_generator"

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
        expect(code.strip).to include("require 'optparse'")
        expect(code.strip).to include("OptionParser.new")
        expect(code.strip).to include("puts \"Hello, \#{")
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

    context "Gemini" do
      before do
        Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
        Sublayer.configuration.ai_model = "gemini-pro"
      end

      it "generates code from description" do
        VCR.use_cassette("gemini/generators/code_from_description_generator/hello_world") do
          code = generate(description: "a hello world app where I pass --who argument to set the 'world' value using optparser")
          expect(code.strip).to eq %q(#!/usr/bin/env ruby

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on('--who WHO', 'Who to greet (default: World)') do |who|
    options[:who] = who
  end
end.parse!

puts "Hello, #{options[:who]}!")
        end
      end
    end
  end
end
