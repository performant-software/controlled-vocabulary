module ControlledVocabulary
  class BaseController < ControlledVocabulary.config.base_controller_class.constantize
    def item_class
      "ControlledVocabulary::#{controller_name.singularize.classify}".constantize
    end

    def serializer_class
      "ControlledVocabulary::#{"#{controller_name}_serializer".classify}".constantize
    end
  end
end
