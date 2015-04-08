module API
  class CollectionsController < APIController

    def index
      @collections = Collection.all

      respond_to do | format |
        format.json { render json: GenerateCollectionJSON.call(@collections) }
      end
    end

    def show
      @collection = Collection.find(params[:id])

      respond_to do | format |
        format.json { render json: GenerateCollectionJSON.call(@collection) }
      end
    end
  end
end
