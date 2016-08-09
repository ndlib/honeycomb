module V1
  # Version 1 API
  class MediaController < APIController
    def create
      @item = ItemQuery.new.public_find(params[:item_id])

      check_user_edits!(@item.collection)

      media = CreateMedia.call(collection: @item.collection, params: create_params)
      render json: media.to_json
    end

    def update
    end

    def start_upload
    end

    def finish_upload
    end

    def create_params
      params.require(:medium)
    end
  end
end
