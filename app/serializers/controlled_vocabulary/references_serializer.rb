module ControlledVocabulary
  class ReferencesSerializer < BaseSerializer
    index_attributes :id, :reference_code_id, :key, reference_code: [:id, :name]
    show_attributes :id, :reference_code_id, :key, reference_code: [:id, :name]
  end
end
