module V1
  # Version 1 API
  class MetadataController < APIController
    def update
      @item = ItemQuery.new.public_find(params[:item_id])

      return if rendered_forbidden?(@item.collection)

      if SaveMetadata.call(@item, save_params)
        render :update
      else
        render :errors, status: :unprocessable_entity
      end
    end

    private

    def save_params
      params[:metadata].to_hash
    end
  end
end
