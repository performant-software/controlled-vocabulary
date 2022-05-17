module ControlledVocabulary
  class ReferencesSerializer < BaseSerializer
    index_attributes :id, :reference_code_id, :key
    show_attributes :id, :reference_code_id, :key
  end
end
