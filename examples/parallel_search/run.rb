# frozen_string_literal: true

require "json"
require "securerandom"
require_relative "parallel_web_action"

usage = 'Usage: bundle exec ruby run.rb search "objective" "query" ["query" ...] | fetch URL [URL ...]'
command, *inputs = ARGV
case command
when "search"
  abort usage unless inputs.length >= 2
  tool = "web_search"
  arguments = { "objective" => inputs.first, "search_queries" => inputs.drop(1) }
when "fetch"
  abort usage if inputs.empty?
  tool = "web_fetch"
  arguments = { "urls" => inputs }
else
  abort usage
end

# Reuse this identifier when making related search/fetch calls in your application.
arguments["session_id"] = SecureRandom.uuid
ParallelSearchExample.with_client do |client|
  result = ParallelSearchExample::ParallelWebAction.new(client: client, tool: tool, arguments: arguments).call
  puts JSON.pretty_generate(result)
end
