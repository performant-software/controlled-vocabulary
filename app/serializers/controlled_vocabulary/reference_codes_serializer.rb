module ControlledVocabulary
  class ReferenceCodesSerializer < BaseSerializer
    index_attributes :id, :reference_table_id, :name
    show_attributes :id, :reference_table_id, :name
  end
end
