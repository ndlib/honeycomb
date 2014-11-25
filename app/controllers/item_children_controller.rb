class ItemChildrenController < ApplicationController

  helper_method :collection
  helper_method :parent

  def index
    @items = ItemsDecorator.new(parent.children)

    respond_to do | format |
      format.json { render json: GenerateItemJson.new(@items, params) }
      format.any { render action: 'index' }
    end
  end

  def new
    @item = parent.children.build(collection: collection)
  end

  def create
    @item = parent.children.build(collection: collection)

    respond_to do |format|
      if SaveItem.call(@item, save_params)

        flash[:notice] = t(:default_create_success_message)

        format.html { redirect_to collection_item_path(collection, parent) }
        format.json { render json: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

    def save_params
      { title: params[:item][:title], description: params[:item][:description], image: params[:item][:image] }
    end

    def parent
      @parent ||= collection.items.find(params[:item_id])
    end

    def collection
      @collection ||= Collection.find(params[:collection_id])
    end
end
