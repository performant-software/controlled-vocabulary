module ControlledVocabulary
  module Referrable
    extend ActiveSupport::Concern

    included do
      # Relationships
      has_many :references, as: :referrable, dependent: :destroy, class_name: 'ControlledVocabulary::Reference'

      # Nested Attributes
      accepts_nested_attributes_for :references, allow_destroy: true

      # Resourceable parameters
      allow_params references_attributes: [:id, :reference_code_id, :key, :_destroy]

      # Callbacks
      before_save :validate_references

      def self.references(*references)
        @references ||= []
        @references << references if references.present?
        @references
      end

      def self.with_reference(reference_key, value)
        self.where(
          Reference
            .joins(:reference_code)
            .where(Reference.arel_table[:referrable_id].eq(self.arel_table[:id]))
            .where(referrable_type: self.to_s, key: reference_key)
            .where(reference_codes: { name: value })
            .arel
            .exists
        )
      end

      private

      def validate_references
        # Find any references with invalid keys
        keys = self.class.references.map{ |k, options| k }
        self.references.each do |reference|
          next if keys.include?(reference.key.to_sym)
          errors.add(:references, "Invalid reference: #{reference.key}")
        end

        self.class.references.each do |key, options = {}|
          records = self.references.select{ |r| r.key.to_sym == key }

          # Find any required references that are not present
          if options[:required] == true && records.size == 0
            self.errors.add(:references, "At least one #{key} is required.")
          end

          # Find any references that do not allow multiple values
          if records.size > 1 && (!options[:multiple].present? || options[:multiple] == false)
            self.errors.add(:references, "Only one #{key} is allowed.")
          end

          throw :abort unless self.errors.empty?
        end
      end
    end
  end
end
