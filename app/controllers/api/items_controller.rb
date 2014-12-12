class Api::ItemsController < ApiController

  helper_method :collection

  def index
    @items = collection.items

    respond_to do | format |
      format.json { render json: GenerateItemJson.new(@items, params) }
    end
  end

  def show
    @item = collection.items.find(params[:id])

    respond_to do | format |
      format.json { render json: GenerateItemJson.new(@item, params) }
    end
  end

  protected

    def collection
      @collection ||= Collection.find(params[:collection_id])
    end

end
