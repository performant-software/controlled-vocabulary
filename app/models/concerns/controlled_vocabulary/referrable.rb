module ControlledVocabulary
  module Referrable
    extend ActiveSupport::Concern

    class_methods do
      # Returns true if the passed attribute allows multiple values
      def allow_multiple?(attribute)
        ((@references || {})[attribute] || {})[:multiple] == true
      end

      # Returns true if the passed attribute is referrable
      def is_referrable?(attribute)
        (@references || {}).keys.include?(attribute)
      end

      def references(key, options = {})
        # Setup the has_many or has_one relationship
        relationship = options[:multiple] == true ? :has_many : :has_one
        self.send(relationship, key.to_sym, -> { where(key: key) }, as: :referrable, dependent: :destroy, class_name: 'ControlledVocabulary::Reference')

        # Nested attributes
        self.send(:accepts_nested_attributes_for, key.to_sym, allow_destroy: true)

        # Resourceable parameters
        self.send(:allow_params, "#{key}_attributes".to_sym => [:id, :reference_code_id, :key, :_destroy])

        @references ||= {}
        @references[key] = options
      end
    end

    included do
      # Relationships
      has_many :references, as: :referrable, dependent: :destroy, class_name: 'ControlledVocabulary::Reference'

      # Callbacks
      before_save :validate_references

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
        return if @references.nil? || @references.empty?

        # Find any references with invalid keys
        self.references.each do |reference|
          next if @references.keys.include?(reference.key.to_sym)
          errors.add(:references, "Invalid reference: #{reference.key}")
        end

        @references.keys.each do |key|
          options = @references[key] || {}

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
