# frozen_string_literal: true

require "zeitwerk"
require 'active_support'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/inflector'
require 'ostruct'
require "httparty"
require "openai"
require "listen"
require "securerandom"
require "time"

require_relative "sublayer/version"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect('open_ai' => 'OpenAI')
loader.inflector.inflect("cli" => "CLI")
loader.ignore("#{__dir__}/sublayer/cli")
loader.ignore("#{__dir__}/sublayer/cli.rb")
loader.setup

module Sublayer
  class Error < StandardError; end

  def self.configuration
    @configuration ||= OpenStruct.new(
      ai_provider: Sublayer::Providers::OpenAI,
      ai_model: "gpt-4o",
      logger: Sublayer::Logging::NullLogger.new
    )
  end

  def self.configure
    yield(configuration) if block_given?
  end
end

loader.eager_load
