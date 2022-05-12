module ControlledVocabulary
  module Queryable
    extend ActiveSupport::Concern

    included do
      def apply_search(query)
        return query unless params[:search].present?

        or_query = nil

        self.class.search_attributes.map do |attr|
          if item_class.is_referrable?(attr.to_sym)
            attr_query = item_class.search_referrable(attr, params[:search])
          else
            attr_query = item_class.where("#{attr} ILIKE ?", "%#{params[:search]}%")
          end

          if or_query.nil?
            or_query = attr_query
          else
            or_query = or_query.or(attr_query)
          end
        end

        query.merge(or_query)
      end

      def apply_sort(query)
        sort_by = params[:sort_by]&.to_sym
        sort_direction = params[:sort_direction] == 'descending' ? :desc : :asc

        return super unless item_class.is_referrable?(sort_by)

        query
          .left_joins(sort_by => :reference_code)
          .order("#{ReferenceCode.table_name}.name" => sort_direction)
      end
    end
  end
end
