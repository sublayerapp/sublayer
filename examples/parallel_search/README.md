# Parallel Search MCP Action

This example wraps the free [Parallel Search MCP](https://docs.parallel.ai/integrations/mcp/search-mcp)
tools in a custom Sublayer Action. `web_search` returns sources and excerpts;
`web_fetch` extracts content from URLs. It uses Streamable HTTP at
`https://search.parallel.ai/mcp`, with no API key or sign-in. Anonymous access has
rate limits and is intended for exploration and light use.

## Run

Use Ruby 3.3 or newer and Bundler. From the repository root:

```sh
cd examples/parallel_search
bundle install
bundle exec ruby run.rb search "Find Sublayer's Action documentation" "Sublayer Ruby custom actions"
bundle exec ruby run.rb fetch https://docs.sublayer.com/
```

Both commands print the MCP result as JSON, including text content. The example
needs no LLM credentials and does not perform model inference. It keeps its MCP
dependency in this directory's Gemfile; Sublayer's default provider stays unchanged.
HTTP and MCP errors raise exceptions; tool errors also raise rather than passing
an error response to a Generator. The MCP request read timeout is configured to
30 seconds and ordinary HTTP retries are disabled. The client can reconnect its
optional event stream. If rate limited, wait before trying again.

## Use in your application

Copy `parallel_web_action.rb` and add `ruby-mcp-client`, `~> 3.0.0`, alongside
Sublayer in your application's Gemfile. Call the Action to gather input for a
Generator or from an Agent's step. Model inference still requires your chosen
provider's credentials. This example demonstrates explicit tool calls; it does
not add automatic model tool selection.

```ruby
require "securerandom"
require_relative "parallel_web_action"

session_id = SecureRandom.uuid # one identifier per conversation
ParallelSearchExample.with_client do |client|
  search = ParallelSearchExample::ParallelWebAction.new(
    client: client,
    tool: "web_search",
    arguments: {
      "objective" => "Find Sublayer's Action documentation",
      "search_queries" => ["Sublayer Ruby custom actions"],
      "session_id" => session_id
    }
  ).call
  puts search

  page = ParallelSearchExample::ParallelWebAction.new(
    client: client,
    tool: "web_fetch",
    arguments: { "urls" => ["https://docs.sublayer.com/"], "session_id" => session_id }
  ).call
  puts page
end
```

The client discovers current tool schemas, validates arguments and closes the
connection when the block exits. It sends a Sublayer User-Agent and no
Authorization header. Search and fetch in the same conversation should reuse
the same `session_id`. See the Parallel documentation for current tool arguments
and service limits.

## Test

From this directory, run `bundle exec rspec spec`. The tests exercise the actual
MCP client with HTTP fixtures, including discovery, headers, tool dispatch,
JSON/SSE responses and error propagation. They do not call the live service.
