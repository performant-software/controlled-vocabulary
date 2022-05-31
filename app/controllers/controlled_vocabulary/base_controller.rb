module ControlledVocabulary
  class BaseController < ControlledVocabulary.config.base_controller_class.constantize
    def self.search_attributes(*attrs)
      super *attrs.map{ |attr| attr.is_a?(Symbol) ? "#{table_name}.#{attr}" : attr }
    end

    def current_user
      return super if defined?(super)

      nil
    end

    def item_class
      "ControlledVocabulary::#{controller_name.singularize.classify}".constantize
    end

    def serializer_class
      "ControlledVocabulary::#{"#{controller_name}_serializer".classify}".constantize
    end

    private

    def self.table_name
      "ControlledVocabulary::#{controller_name.singularize.classify}".constantize.table_name
    end
  end
end
