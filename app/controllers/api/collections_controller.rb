class Api::CollectionsController < ApiController

  def index
    @collections = Collection.all

    respond_to do | format |
      format.json { render json: GenerateCollectionJson.call(@collections) }
    end
  end

  def show
    @collection = Collection.find(params[:id])

    respond_to do | format |
      format.json { render json: GenerateCollectionJson.call(@collection) }
    end
  end

end
