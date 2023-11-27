# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/hash/indifferent_access'
require_relative "sublayer/version"

if !File.directory?(File.join(Dir.pwd, ".sublayer", "agents"))
  Dir.mkdir(File.join(Dir.pwd, ".sublayer"))
  Dir.mkdir(File.join(Dir.pwd, ".sublayer", "agents"))
end

# List of directories to load files from
LOAD_PATHS = [
  File.join(__dir__, 'sublayer', 'capabilities'),
  File.join(__dir__, 'sublayer', 'components'),
  File.join(__dir__, 'sublayer', 'agents'),
  File.join(Dir.pwd, '.sublayer', 'agents')
]


# Load files from each directory in the list
LOAD_PATHS.each do |load_path|
  Dir.glob(File.join(load_path, '*.rb')).each do |file|
    require_relative file
  end
end

require_relative "sublayer/enhancements/json.rb"

module Sublayer
  class Error < StandardError; end

  # Defines a method to reload all the agents
  def self.reload_agents
    LOAD_PATHS.each do |load_path|
      Dir.glob(File.join(load_path, '*.rb')) do |file|
        load file
      end
    end
  end

  def self.cwd
    Dir.pwd
  end
end
