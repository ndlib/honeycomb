module V1
  class ShowcasesController < APIController
    def index
      collection = CollectionQuery.new.any_find(params[:collection_id])
      @collection = CollectionJSONDecorator.new(collection)

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::V1Showcases,
                                           action: "index",
                                           collection: collection)
      fresh_when(etag: cache_key.generate)
    end

    def show
      showcase = ShowcaseQuery.new.public_find(params[:id])
      @showcase = ShowcaseJSONDecorator.new(showcase)

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::V1Showcases,
                                           action: "show",
                                           showcase: @showcase)
      fresh_when(etag: cache_key.generate)
    end

    def destroy
      @showcase = ShowcaseQuery.new.public_find(params[:id])
      return if rendered_forbidden?(@showcase.collection)

      if Destroy::Showcase.new.cascade!(showcase: @showcase)
        render json: { status: "Success" }
      else
        render json: { status: "Unable to delete item" }, status: :unprocessable_entity
      end
    end
  end
end
