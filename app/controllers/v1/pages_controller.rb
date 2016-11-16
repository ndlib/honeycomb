module V1
  class PagesController < APIController
    def index
      collection = CollectionQuery.new.any_find(params[:collection_id])
      @collection = CollectionJSONDecorator.new(collection)

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::V1Pages,
                                           action: "index",
                                           collection: collection)
      fresh_when(etag: cache_key.generate)
    end

    def show
      page = PageQuery.new.public_find(params[:id])
      @page = PageJSONDecorator.new(page)

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::V1Pages,
                                           action: "show",
                                           page: @page)
      fresh_when(etag: cache_key.generate)
    end

    def destroy
      @page = PageQuery.new.public_find(params[:id])
      return if rendered_forbidden?(@page.collection)

      if Destroy::Page.new.cascade!(page: @page)
        render json: { status: "Success" }
      else
        render json: { status: "Unable to delete item" }, status: :unprocessable_entity
      end
    end
  end
end
