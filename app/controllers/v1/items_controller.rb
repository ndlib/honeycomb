module V1
  # Version 1 API
  class ItemsController < APIController
    # API controller for items
    def index
      collection = CollectionQuery.new.any_find(params[:collection_id])
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

    def create
      @collection = CollectionQuery.new.any_find(params[:collection_id])
      @item = ItemQuery.new(@collection.items).build

      return if rendered_forbidden?(@item.collection)

      if SaveItem.call(@item, save_params)
        render :create
      else
        render :errors, status: :unprocessable_entity
      end
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

    def destroy
      @item = ItemQuery.new.public_find(params[:id])
      return if rendered_forbidden?(@item.collection)

      if Destroy::Item.new.destroy!(item: @item)
        render json: "Success"
      else
        render json: "Unable to delete item", status: :unprocessable_entity
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

    # get all pages that use the given item
    def pages
      @item = ItemQuery.new.public_find(params[:item_id])

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::V1Items,
                                           action: "pages",
                                           item: @item)
      fresh_when(etag: cache_key.generate)
    end

    protected

    def save_params
      params[:item].to_hash
    end
  end
end
