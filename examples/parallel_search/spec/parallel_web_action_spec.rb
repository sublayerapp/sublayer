# frozen_string_literal: true

require "json"
require "uri"
require "rspec"
require "webmock/rspec"
require_relative "../parallel_web_action"

RSpec.describe ParallelSearchExample::ParallelWebAction do
  let(:endpoint) { ParallelSearchExample::ENDPOINT }
  let(:session_id) { "e4277569-2909-471b-a940-e63dc38cfd45" }
  let(:search_arguments) do
    { "objective" => "Find Ruby documentation", "search_queries" => ["Ruby language documentation"],
      "session_id" => session_id }
  end
  let(:tool_result) { { "content" => [{ "type" => "text", "text" => "Ruby documentation: https://www.ruby-lang.org/" }] } }
  let(:response_type) { "application/json" }

  before do
    @requests = []
    stub_request(:post, endpoint).to_return do |request|
      rpc = JSON.parse(request.body)
      @requests << { rpc: rpc, headers: request.headers, url: request.uri.to_s }
      result = case rpc["method"]
               when "initialize"
                 { "protocolVersion" => "2025-11-25", "capabilities" => { "tools" => {} },
                   "serverInfo" => { "name" => "parallel-fixture", "version" => "1.0" } }
               when "tools/list"
                 { "tools" => [
                   { "name" => "web_search", "description" => "Search the web", "inputSchema" => {
                     "type" => "object", "properties" => {
                       "objective" => { "type" => "string" },
                       "search_queries" => { "type" => "array", "items" => { "type" => "string" } },
                       "session_id" => { "type" => "string" }
                     }, "required" => ["objective", "search_queries"]
                   } },
                   { "name" => "web_fetch", "description" => "Fetch URLs", "inputSchema" => {
                     "type" => "object", "properties" => {
                       "urls" => { "type" => "array", "items" => { "type" => "string" } },
                       "session_id" => { "type" => "string" }
                     }, "required" => ["urls"]
                   } }
                 ] }
               when "tools/call"
                 tool_result
               end
      if rpc["method"] == "notifications/initialized"
        { status: 202, body: "" }
      else
        body = JSON.generate({ "jsonrpc" => "2.0", "id" => rpc["id"], "result" => result })
        content_type = rpc["method"] == "tools/call" ? response_type : "application/json"
        body = "event: message\ndata: #{body}\n\n" if content_type == "text/event-stream"
        { status: 200, headers: { "Content-Type" => content_type }, body: body }
      end
    end
  end

  def call_action(client, tool, arguments)
    described_class.new(client: client, tool: tool, arguments: arguments).call
  end

  it "discovers and dispatches search and fetch through Sublayer Actions anonymously" do
    defaults = [Sublayer.configuration.ai_provider, Sublayer.configuration.ai_model]
    expect(described_class.superclass).to eq(Sublayer::Actions::Base)
    ParallelSearchExample.with_client do |client|
      expect(call_action(client, "web_search", search_arguments)).to eq(tool_result)
      expect(call_action(client, "web_fetch", { "urls" => ["https://www.ruby-lang.org/"],
                                               "session_id" => session_id })).to eq(tool_result)
    end
    calls = @requests.select { |request| request[:rpc]["method"] == "tools/call" }
    expect(calls.map { |request| request[:rpc]["params"]["name"] }).to eq(%w[web_search web_fetch])
    expect(calls.first[:rpc]["params"]["arguments"]).to eq(search_arguments)
    expect(calls.last[:rpc]["params"]["arguments"]["session_id"]).to eq(session_id)
    expect(@requests.map { |request| request[:rpc]["method"] }).to include("initialize", "tools/list")
    @requests.each do |request|
      expect(URI(request[:url])).to eq(URI(endpoint))
      expect(request[:headers]["User-Agent"]).to eq(ParallelSearchExample::USER_AGENT)
      expect(request[:headers]).not_to have_key("Authorization")
    end
    expect([Sublayer.configuration.ai_provider, Sublayer.configuration.ai_model]).to eq(defaults)
  end

  context "with an SSE response" do
    let(:response_type) { "text/event-stream" }

    it "returns the parsed MCP content" do
      ParallelSearchExample.with_client do |client|
        expect(call_action(client, "web_search", search_arguments)).to eq(tool_result)
      end
    end
  end

  context "when a tool fails" do
    let(:tool_result) { { "isError" => true, "content" => [{ "type" => "text", "text" => "Fetch failed" }] } }

    it "raises the tool error and cleans up the connection" do
      expect do
        ParallelSearchExample.with_client do |client|
          expect(client).to receive(:cleanup).and_call_original
          call_action(client, "web_fetch", { "urls" => ["https://example.com/"] })
        end
      end.to raise_error(described_class::ToolError, "Fetch failed")
    end
  end

  it "validates required arguments before sending a tool call" do
    ParallelSearchExample.with_client do |client|
      expect { call_action(client, "web_search", { "objective" => "Missing queries" }) }
        .to raise_error(MCPClient::Errors::ValidationError)
    end
    expect(@requests.none? { |request| request[:rpc]["method"] == "tools/call" }).to be true
  end

  it "propagates HTTP failures without retrying the tool call" do
    stub_request(:post, endpoint).with { |request| JSON.parse(request.body)["method"] == "tools/call" }
      .to_return(status: 503, body: "Service unavailable")
    ParallelSearchExample.with_client do |client|
      expect { call_action(client, "web_search", search_arguments) }.to raise_error(MCPClient::Errors::ToolCallError)
    end
    expect(a_request(:post, endpoint).with { |request| JSON.parse(request.body)["method"] == "tools/call" })
      .to have_been_made.once
  end
end
