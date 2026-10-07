# frozen_string_literal: true

require "sublayer"
require "mcp_client"
require "logger"

module ParallelSearchExample
  ENDPOINT = "https://search.parallel.ai/mcp"
  USER_AGENT = "sublayer/#{Sublayer::VERSION} (Parallel Search MCP example)"

  # The transport sets its own User-Agent after applying configured headers.
  # Set ours at the request boundary so discovery and tool calls identify Sublayer.
  class UserAgent < Faraday::Middleware
    def call(env)
      env.request_headers["User-Agent"] = USER_AGENT
      @app.call(env)
    end
  end

  def self.with_client
    logger = Logger.new($stderr, level: Logger::WARN)
    config = MCPClient.streamable_http_config(
      base_url: ENDPOINT,
      protocol: :legacy,
      logger: logger,
      read_timeout: 30,
      retries: 0
    ) do |connection|
      connection.builder.insert(0, UserAgent)
    end
    client = MCPClient.create_client(mcp_server_configs: [config], logger: logger)
    client.list_tools
    yield client
  ensure
    client&.cleanup
  end

  class ParallelWebAction < Sublayer::Actions::Base
    class ToolError < StandardError; end

    def initialize(client:, tool:, arguments:)
      @client = client
      @tool = tool
      @arguments = arguments
    end

    def call
      result = @client.call_tool(@tool, @arguments)
      if result["isError"]
        message = result.fetch("content", []).filter_map { |item| item["text"] }.join("\n")
        raise ToolError, message.empty? ? "#{@tool} failed" : message
      end

      result
    end
  end
end
