module V1
  # Version 1 API
  class MediaController < APIController
    def create_for_item
      @item = ItemQuery.new.public_find(params[:item_id])

      check_user_edits!(@item.collection)

      media = CreateMedia.call(owner: @item, collection: @item.collection, params: create_params)
      status = media.valid? ? :ok : :unprocessable_entity
      render json: media.to_json, status: status
    end

    def finish_upload
      @media = MediaQuery.new.public_find

      FinishMediaUpload.call(media: @media)

      status = @media.valid? ? :ok : :unprocessable_entity
      render json: @media.to_json, status: status
    end

    def update
      @media = MediaQuery.new.public_find(media_params[:id])
      @uploaded_image = media_params[:uploaded_image]
      return_value = SaveMediaThumbnail.call(
        image: media_params[:uploaded_image],
        item: @media.items[0],
        media: @media
      ) if @uploaded_image.present?

      status = return_value ? :ok : :unprocessable_entity
      render json: SerializeMedia.to_json(media: @media), status: status
    end

    private

    def create_params
      params.require(:medium)
    end

    def media_params
      params[:media].to_hash.with_indifferent_access
    end
  end
end
