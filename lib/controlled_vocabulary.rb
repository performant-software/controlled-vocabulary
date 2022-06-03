require 'controlled_vocabulary/version'
require 'controlled_vocabulary/engine'
require 'controlled_vocabulary/configuration'

module ControlledVocabulary
  mattr_accessor :config, default: Configuration.new

  def self.configure(&block)
    block.call self.config
  end
end
