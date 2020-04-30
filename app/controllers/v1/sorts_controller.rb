module V1
  class SortsController < APIController
    def update
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      result = Metadata::UpdateConfigurationSort.call(@collection, params[:id], sort_params)
      if result
        render json: { sort: result }.to_json
      else
        render status: :unprocessable_entity, json: { sort: sort_params }.to_json
      end
    end

    def create
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      result = Metadata::CreateConfigurationSort.call(@collection, sort_params)
      if result
        render json: { sort: result }.to_json
      else
        render status: :unprocessable_entity, json: { sort: sort_params }.to_json
      end
    end

    def destroy
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      result = Metadata::RemoveConfigurationSort.call(@collection, params[:id])
      if result
        render json: { success: true }.to_json
      else
        render status: :unprocessable_entity, json: { success: false, id: params[:id] }.to_json
      end
    end

    def reorder
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      if ReorderSorts.call(@collection, sort_params)
        render json: { new_order: reorder_params }.to_json
      else
        render :errors, status: :unprocessable_entity
      end
    end

    private

    def sort_params
      @sort_params ||= params[:sorts] ? params[:sorts] : params.except(:format, :controller, :action, :collection_id, :id)
    end

    def reorder_params
      params.require(:sorts)
    end
  end
end
