module V1
  class MetadataFieldsController < APIController
    def update
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      result = Metadata::UpdateConfigurationField.call(@collection, params[:id], field_params)
      if result
        render json: { field: result }.to_json
      else
        render status: :unprocessable_entity, json: { field: field_params }.to_json
      end
    end

    def create
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      result = Metadata::CreateConfigurationField.call(@collection, field_params)
      if result
        render json: { field: result }.to_json
      else
        render status: :unprocessable_entity, json: { field: field_params }.to_json
      end
    end

    def reorder
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      if ReorderMetadata.call(@collection, save_params)
        render :update
      else
        render :errors, status: :unprocessable_entity
      end
    end

    private

    def field_params
      @field_params ||= params[:fields] ? params[:fields] : {}
    end
  end
end
