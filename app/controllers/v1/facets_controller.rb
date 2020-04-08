module V1
  class FacetsController < APIController
    def update
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      result = Metadata::UpdateConfigurationFacet.call(@collection, params[:id], facet_params)
      if result
        render json: { facet: result }.to_json
      else
        render status: :unprocessable_entity, json: { facet: facet_params }.to_json
      end
    end

    def create
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      result = Metadata::CreateConfigurationFacet.call(@collection, facet_params)
      if result
        render json: { facet: result }.to_json
      else
        render status: :unprocessable_entity, json: { facet: facet_params }.to_json
      end
    end

    def destroy
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      result = Metadata::RemoveConfigurationFacet.call(@collection, params[:id])
      if result
        render json: { success: true }.to_json
      else
        render status: :unprocessable_entity, json: { success: false }.to_json
      end
    end

    def reorder
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      if ReorderFacets.call(@collection, facet_params)
        render json: { new_order: reorder_params }.to_json
      else
        render :errors, status: :unprocessable_entity
      end
    end

    private

    def facet_params
      @facet_params ||= params[:facets] ? params[:facets] : params.except(:format, :controller, :action, :collection_id, :id)
    end

    def reorder_params
      params.require(:facets)
    end
  end
end
