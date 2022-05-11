module ControlledVocabulary
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    include Resourceable
  end
end
