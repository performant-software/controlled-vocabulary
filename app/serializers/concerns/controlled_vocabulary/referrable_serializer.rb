module ControlledVocabulary
  module ReferrableSerializer
    extend ActiveSupport::Concern

    included do
      def extract_value(serialized, item, attribute)
        super unless item.class.is_referrable?(attribute)
        return unless item.class.is_referrable?(attribute)

        attribute_view = "#{attribute}_view"
        references_serializer = ReferencesSerializer.new

        serialized[attribute] = []
        serialized[attribute_view] = []

        item.send(attribute)&.each do |reference|
          serialized[attribute] << references_serializer.render_index(reference)
          serialized[attribute_view] << reference.reference_code&.name
        end
      end
    end
  end
end
