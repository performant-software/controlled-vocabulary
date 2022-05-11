module ControlledVocabulary
  class ReferenceTablesSerializer < ::BaseSerializer
    index_attributes :id, :name, :key, :created_at, :updated_at
    show_attributes :id, :name, :key, :created_at, :updated_at, reference_codes: [:id, :name, :created_at, :updated_at]
  end
end
