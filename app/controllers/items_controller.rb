class ItemsController < ApplicationController

  helper_method :collection

  def index
    @items = collection.items

    respond_to do | format |
      format.json { render json: GenerateItemJson.new(@items, params) }
      format.any { render action: 'index' }
    end
  end

  def new
    @item = collection.items.build
  end

  def show
    @item = collection.items.find(params[:id])

    respond_to do | format |
      format.json { render json: GenerateItemJson.new(@item, params) }
      format.any { render action: 'show' }
    end
  end

  def create
    @item = collection.items.build

    respond_to do |format|
      if SaveItem.call(@item, save_params)

        flash[:notice] = t(:default_create_success_message)

        format.html { redirect_to collection_items_path(@item.collection) }
        format.json { render json: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @item = collection.items.find(params[:id])
  end

  def update
    @item = collection.items.find(params[:id])

    respond_to do |format|
      if SaveItem.call(@item, save_params)
        flash[:notice] = t(:default_update_success_message)

        format.html { redirect_to collection_items_path(@item.collection) }
        format.json { render json: @item }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @item = collection.items.find(params[:id])

    if @item.destroy
      flash[:notice] = t(:default_destroy_success_message)
    else
      flash[:error] = t(:default_destroy_failure_message)
    end

    redirect_to collection_items_path(@item.collection)
  end

  protected

    def save_params
      { title: params[:item][:title], description: params[:item][:description], image: params[:item][:image] }
    end


    def collection
      @collection ||= Collection.find(params[:collection_id])
    end
end
