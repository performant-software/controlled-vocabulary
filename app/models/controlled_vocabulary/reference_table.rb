module ControlledVocabulary
  class ReferenceTable < ApplicationRecord
    has_many :reference_codes, dependent: :destroy
  end
end
