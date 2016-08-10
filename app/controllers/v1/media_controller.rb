module V1
  # Version 1 API
  class MediaController < APIController
    def create_for_item
      @item = ItemQuery.new.public_find(params[:item_id])

      #check_user_edits!(@item.collection)

      media = CreateMedia.call(owner: @item, collection: @item.collection, params: create_params)
      status = media.valid? ? :ok : :unprocessable_entity
      render json: media.to_json, status: status
    end

    private

    def create_params
      params.require(:medium)
    end
  end
end
