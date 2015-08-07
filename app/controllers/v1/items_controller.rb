module V1
  # Version 1 API
  class ItemsController < APIController
    # API controller for items
    def index
      collection = CollectionQuery.new.public_find(params[:collection_id])
      @collection = CollectionJSONDecorator.new(collection)

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::V1Items,
                                           action: "index",
                                           collection: collection)
      fresh_when(etag: cache_key.generate)
    end

    def show
      @item = ItemQuery.new.public_find(params[:id])

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::V1Items,
                                           action: "show",
                                           item: @item)
      fresh_when(etag: cache_key.generate)
    end

    def update
      @item = ItemQuery.new.public_find(params[:id])

      return if rendered_forbidden?(@item.collection)

      if SaveItem.call(@item, save_params)
        render :update
      else
        render :errors, status: :unprocessable_entity
      end
    end

    # get all showcases that use the given item
    def showcases
      @item = ItemQuery.new.public_find(params[:item_id])

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::V1Items,
                                           action: "showcases",
                                           item: @item)
      fresh_when(etag: cache_key.generate)
    end

    protected

    def save_params
      params.require(:item).permit(
        :name,
        :description,
        :image,
        :manuscript_url,
        :transcription,
        :rights,
        :subject,
        :provenance,
        :original_language,
        :uploaded_image,
        :call_number,
        date_created: [:value, :year, :month, :day, :bc, :display_text],
        date_modified: [:value, :year, :month, :day, :bc, :display_text],
        date_published: [:value, :year, :month, :day, :bc, :display_text],
        creator: [],
        publisher: [],
        alternate_name: [],
        contributor: [],
      )
    end
  end
end
