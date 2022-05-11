require 'controlled_vocabulary/version'
require 'controlled_vocabulary/engine'
require 'controlled_vocabulary/configuration'

module ControlledVocabulary
  mattr_accessor :config

  def self.configure(&block)
    self.config ||= Configuration.new
    block.call self.config
  end
end
