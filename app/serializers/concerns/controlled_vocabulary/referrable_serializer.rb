module ControlledVocabulary
  module ReferrableSerializer
    extend ActiveSupport::Concern

    included do
      def extract_value(serialized, item, attribute)
        super unless item.class.is_referrable?(attribute)
        return unless item.class.is_referrable?(attribute)

        if item.class.allow_multiple?(attribute)
          extract_has_many serialized, item, attribute
        else
          extract_has_one serialized, item, attribute
        end
      end

      private

      def extract_has_many(serialized, item, attribute)
        serialized[attribute] = []

        item.send(attribute)&.each do |reference|
          serialized[attribute] << reference.reference_code&.name
        end
      end

      def extract_has_one(serialized, item, attribute)
        reference = item.send(attribute)
        serialized[attribute] = reference&.reference_code&.name
      end
    end
  end
end
