module ControlledVocabulary
  class ReferenceTablesController < BaseController
    # Search attributes
    search_attributes :name

    def find_by_key
      render json: { errors: [I18n.t('errors.parameter_required', name: 'key')] }, status: :unprocessable_entity and return unless params[:key]

      query = base_query
      query = build_query(query)

      item = query.find_by(key: params[:key])
      item_name = param_name.to_sym

      item = prepare_item(item)
      preloads(item)

      serializer = serializer_class.new(current_user)
      render json: { item_name => serializer.render_show(item) }
    end
  end
end
