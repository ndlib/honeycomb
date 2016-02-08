module V1
  class CollectionsController < APIController
    def index
      @collections = CollectionQuery.new.public_collections

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::V1Collections,
                                           action: "index",
                                           collections: @collections)
      fresh_when(etag: cache_key.generate)
    end

    def show
      @collection = CollectionQuery.new.public_find(params[:id])

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::V1Collections,
                                           action: "show",
                                           collection: @collection)
      fresh_when(etag: cache_key.generate)
    end

    def publish
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      @return_value = Publish.call(@collection)

      respond_to do |format|
        format.json { render json: { status: @return_value }.to_json }
      end
    end

    def unpublish
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      @return_value = Unpublish.call(@collection)

      respond_to do |format|
        format.json { render json: { status: @return_value }.to_json }
      end
    end

    def preview_mode
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      @return_value = SetCollectionPreviewMode.call(@collection, params[:value])

      respond_to do |format|
        format.json { render json: { status: @return_value }.to_json }
      end
    end

    def metadata_configuration
      collection = CollectionQuery.new.any_find(params[:collection_id])
      @configuration = CollectionConfigurationQuery.new(collection).find
      @configuration = Metadata::Configuration.new(@configuration)
      @configuration = V1::MetadataConfigurationJSON.new(@configuration)

      respond_to do |format|
        format.json { render json: @configuration.to_json }
      end
    end

    def site_path
      collection = CollectionQuery.new.any_find(params[:collection_id])
      @collection = CollectionJSONDecorator.new(collection)
      @site_path = SiteObjectsQuery.new.all(collection: collection)
      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::V1Collections,
                                           action: "site_path",
                                           collection: collection, site_path: @site_path)
      fresh_when(etag: cache_key.generate)
    end

    def site_path_update
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      site_path = SiteObjectsQuery.new.public_to_private_json(json_string: params[:site_path])
      @return_value = SaveCollection.call(@collection, site_path: site_path)

      respond_to do |format|
        format.json { render json: { status: @return_value }.to_json }
      end
    end
  end
end
