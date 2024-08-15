#frozen_string_literal: true

require "sinatra/base"
require_relative "config/environment"

module ProjectName
  class App < Sinatra::Base
    get  "/" do
      "Welcome to your Sublayer Web Service!"
    end

    get "/example" do
      agent = ProjectName::Agents::ExampleAgent.new
      agent.run
      "Example agent ran successfully"
    end

    get "/generate" do
      generator = ProjectName::Generators::ExampleGenerator.new(input: params[:input])
      result = generator.generate

      "Generated result: #{result}"
    end
  end
end

