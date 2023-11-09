# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/hash/indifferent_access'
require_relative "sublayer/version"

# List of directories to load files from
@load_paths = [
  File.join(__dir__, 'sublayer', 'capabilities'),
  File.join(__dir__, 'sublayer', 'components'),
  File.join(__dir__, 'sublayer', 'agents'),
  File.join(Dir.pwd, '.sublayer', 'agents')
]

if !File.directory?(@load_paths.last)
  Dir.mkdir(File.join(Dir.pwd, ".sublayer"))
  Dir.mkdir(File.join(Dir.pwd, ".sublayer", "agents"))
end

# Load files from each directory in the list
@load_paths.each do |load_path|
  Dir.glob(File.join(load_path, '*.rb')).each do |file|
    require_relative file
  end
end

require_relative "sublayer/enhancements/json.rb"

module Sublayer
  class Error < StandardError; end

  # Defines a method to reload all the agents
  def self.reload_agents
    @load_paths.each do |load_path|
      Dir.glob(File.join(load_path, '*.rb')) do |file|
        load file
      end
    end
  end

  def self.cwd
    Dir.pwd
  end
end
