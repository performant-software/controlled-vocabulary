module ControlledVocabulary
  class ReferenceTable < ApplicationRecord
    # Relationships
    has_many :reference_codes, dependent: :destroy

    # Nested attributes
    accepts_nested_attributes_for :reference_codes, allow_destroy: true

    # Resourceable parameters
    allow_params :name, :key, reference_codes_attributes: [:id, :name, :_destroy]
  end
end
