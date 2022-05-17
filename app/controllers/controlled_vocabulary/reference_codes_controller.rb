module ControlledVocabulary
  class ReferenceCodesController < BaseController
    search_attributes :name

    def index
      super and return unless params[:reference_table].nil?

      render json: { errors: 'Reference table key is required' }, status: 400
    end

    def apply_filters(query)
      query = super
      query = filter_ids(query)

      query
    end

    protected

    def base_query
      ReferenceCode
        .joins(:reference_table)
        .where("#{ReferenceTable.table_name}" => { key: params[:reference_table] })
    end

    private

    def filter_ids(query)
      return query unless params[:ids].present?

      query.where(id: params[:ids])
    end
  end
end
