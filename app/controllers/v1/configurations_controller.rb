module V1
  class ConfigurationsController < APIController
    def show
      collection = CollectionQuery.new.any_find(params[:collection_id])
      @configuration = CollectionConfigurationQuery.new(collection).find
      @configuration = V1::MetadataConfigurationJSON.new(@configuration, collection)

      respond_to do |format|
        format.json { render json: @configuration.to_json }
      end
    end
  end
end
