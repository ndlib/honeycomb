module V1
  class CollectionsController < APIController

    def index
      @collections = CollectionQuery.new.public_collections
    end

    def show
      @collection = CollectionQuery.new.public_find(params[:id])
    end
  end
end

