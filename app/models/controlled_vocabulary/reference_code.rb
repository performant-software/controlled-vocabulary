module ControlledVocabulary
  class ReferenceCode < ApplicationRecord
    # Relationships
    belongs_to :reference_table
    has_many :references, dependent: :destroy
  end
end
