class ItemsController < ApplicationController

  helper_method :collection

  def index
    items = ItemQuery.new(collection.items).search.exclude_children
    @items = ItemsDecorator.new(items)
  end

  def new
    @item = collection.items.build
  end

  def show
    @item = ItemDecorator.new(collection.items.find(params[:id]))
  end

  def create
    @item = collection.items.build

    if SaveItem.call(@item, save_params)
      item_save_success(@item)
    else
      item_save_failure(@item)
    end
  end

  def edit
    @item = collection.items.find(params[:id])
  end

  def update
    @item = collection.items.find(params[:id])

    if SaveItem.call(@item, save_params)
      item_save_success(@item)
    else
      item_save_failure(@item)
    end
  end

  def destroy
    @item = collection.items.find(params[:id])

    if @item.destroy
      flash[:notice] = t('.success')
    else
      flash[:error] = t('.failure')
    end

    redirect_to collection_items_path(@item.collection)
  end

  protected

    def save_params
      params.require(:item).permit(:title, :description, :image, :manuscript_url)
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
      if params[:action] == 'create'
        redirect_to collection_items_path(collection)
      else
        redirect_to collection_item_path(collection, item)
      end
    end

    def item_save_failure(item)
      respond_to do |format|
        format.html do
          if params[:action] == 'create'
            render action: 'new'
          else
            render action: 'edit'
          end
        end
        format.json { render json: item.errors, status: :unprocessable_entity }
      end
    end
end
