module ControlledVocabulary
  class Reference < ApplicationRecord
    belongs_to :referrable, polymorphic: true
    belongs_to :reference_code
  end
end
