module ControlledVocabulary
  module Queryable
    extend ActiveSupport::Concern

    included do
      sort_methods :apply_controlled_vocabulary_sort

      def apply_controlled_vocabulary_sort(query)
        sort_by = params[:sort_by]&.to_sym
        sort_direction = params[:sort_direction] == 'descending' ? :desc : :asc

        return query unless item_class.respond_to?(:is_referrable?) && item_class.is_referrable?(sort_by)

        query
          .left_joins(sort_by => :reference_code)
          .order("#{ReferenceCode.table_name}.name" => sort_direction)
      end

      def resolve_search_query(attr)
        return super unless is_referrable?(attr)

        item_class.search_referrable(attr, params[:search])
      end

      private

      def is_referrable?(attr)
        item_class.respond_to?(:is_referrable?) && item_class.is_referrable?(attr)
      end
    end
  end
end
