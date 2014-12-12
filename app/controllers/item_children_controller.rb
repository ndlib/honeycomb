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

    if SaveItem.call(@item, save_params)
      item_save_success(@item)
    else
      item_save_failure(@item)
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

    def item_save_success(item)
      respond_to do |format|
        format.json { render json: item }
        format.html do
          item_save_html_success(item)
        end
      end
    end

    def item_save_html_success(item)
      flash[:notice] = t('.success')
      redirect_to collection_item_path(collection, parent)
    end

    def item_save_failure(item)
      respond_to do |format|
        format.html { render action: 'new'}
        format.json { render json: item.errors, status: :unprocessable_entity }
      end
    end
end
