module API
  class ItemsController < APIController
    helper_method :collection

    def index
      @items = ItemQuery.new(collection.items).published

      respond_to do |format|
        format.json { render json: GenerateItemJSON.new(@items, params) }
      end
    end

    def show
      @item = collection.items.find(params[:id])

      respond_to do |format|
        format.json { render json: GenerateItemJSON.new(@item, params) }
      end
    end

    protected

    def collection
      @collection ||= Collection.find(params[:collection_id])
    end
  end
end
