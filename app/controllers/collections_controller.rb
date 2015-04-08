class CollectionsController < ApplicationController

  def index
    @collections = CollectionQuery.new.for_editor(current_user)
  end

  def show
    redirect_to collection_items_path(params[:id])
  end

  def new
    check_admin_or_admin_masquerading_permission!

    @collection = CollectionQuery.new.build
  end

  def create
    check_admin_or_admin_masquerading_permission!

    @collection = CollectionQuery.new.build

    if SaveCollection.call(@collection, save_params)
      flash[:notice] = t('.success')
      redirect_to collection_path(@collection)
    else
      render :new
    end
  end

  def edit
    @collection = CollectionQuery.new.find(params[:id])
    check_user_edits!(@collection)
  end

  def update
    @collection = CollectionQuery.new.find(params[:id])
    check_user_edits!(@collection)

    if SaveCollection.call(@collection, save_params)
      flash[:notice] = t('.success')
      redirect_to edit_collection_path(@collection)
    else
      render :edit
    end
  end

  def destroy
    check_admin_or_admin_masquerading_permission!

    @collection = CollectionQuery.new.find(params[:id])
    @collection.destroy!

    flash[:notice] = t('.success')
    redirect_to collections_path
  end

  def exhibit
    collection = CollectionQuery.new.find(params[:collection_id])
    exhibit = EnsureCollectionHasExhibit.call(collection)

    redirect_to exhibit_path(exhibit)
  end

  protected

    def save_params
      params.require(:collection).permit(:title, :description, :id)
    end

end
