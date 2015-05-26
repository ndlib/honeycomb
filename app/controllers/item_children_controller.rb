class ItemChildrenController < ApplicationController
  def new
    check_user_edits!(parent.collection)
    @item = ItemQuery.new(parent.children).build(collection_id: parent.collection.id)
  end

  def create
    check_user_edits!(parent.collection)
    @item = ItemQuery.new(parent.children).build(collection_id: parent.collection.id)

    if SaveItem.call(@item, save_params)
      item_save_success(@item)
    else
      item_save_failure(@item)
    end
  end

  protected

  def save_params
    { name: params[:item][:name], description: params[:item][:description], image: params[:item][:image] }
  end

  def parent
    @parent ||= ItemQuery.new.find(params[:item_id])
  end

  def item_save_success(item)
    respond_to do |format|
      format.json { render json: item }
      format.html do
        item_save_html_success(item)
      end
    end
  end

  def item_save_html_success(_item)
    flash[:notice] = t(".success")
    redirect_to edit_item_path(parent)
  end

  def item_save_failure(item)
    respond_to do |format|
      format.html { render action: "new" }
      format.json { render json: item.errors, status: :unprocessable_entity }
    end
  end
end
