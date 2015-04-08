class ItemsController < ApplicationController

  def index
    check_user_edits!(collection)

    items = ItemQuery.new(collection.items).only_top_level
    @items = ItemsDecorator.new(items)
  end

  def new
    check_user_edits!(collection)

    @item = ItemQuery.new(collection.items).build
  end

  def create
    check_user_edits!(collection)

    @item = ItemQuery.new(collection.items).build

    if SaveItem.call(@item, save_params)
      item_save_success(@item)
    else
      item_save_failure(@item)
    end
  end

  def edit
    item = ItemQuery.new.find(params[:id])
    check_user_edits!(item.collection)

    @item = ItemDecorator.new(item)
  end

  def update
    @item = ItemQuery.new.find(params[:id])
    check_user_edits!(@item.collection)

    if SaveItem.call(@item, save_params)
      item_save_success(@item)
    else
      item_save_failure(@item)
    end
  end

  def destroy
    @item = ItemQuery.new.find(params[:id])
    check_user_edits!(@item.collection)

    @item.destroy!
    flash[:notice] = t('.success')

    redirect_to collection_path(@item.collection)
  end

  def publish
    @item = ItemQuery.new.find(params[:id])
    check_user_edits!(@item.collection)

    if !Publish.call(@item)
      raise "Error publishing #{@item.title}"
    end

    item_save_success(@item)
  end

  def unpublish
    @item = ItemQuery.new.find(params[:id])
    check_user_edits!(@item.collection)

    if !Unpublish.call(@item)
      raise "Error unpublishing #{@item.title}"
    end

    item_save_success(@item)
  end

  protected

    def save_params
      params.require(:item).permit(:title, :description, :image, :manuscript_url, :transcription)
    end

    def collection
      @collection ||= CollectionQuery.new.find(params[:collection_id])
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
      if item.parent.present?
        redirect_to edit_item_path(item.parent)
      else
        redirect_to collection_path(item.collection)
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
