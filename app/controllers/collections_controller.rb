class CollectionsController < ApplicationController

  def index
    @collections = Collection.all
  end

  def new
    @collection = Collection.new
  end

  def edit
    @collection = Collection.find(params[:id])
  end

  def create
    @collection = Collection.new(params.require(:collection).permit([:title]))

    if @collection.save
      puts @collection.title
      redirect_to @collection
    else
      render :new
    end
  end

  def soft_delete
    check_admin_or_admin_masquerading_permission!

    @collection = Collection.find(params[:collection_id])
    SoftDeleteCollection.call(@collection)
    flash[:notice] = @collection.title + " has been deleted."
    redirect_to collections_path
  end

    def restore
    check_admin_or_admin_masquerading_permission!

    @collection = Collection.find(params[:collection_id])
    RestoreCollection.call(@collection)
    flash[:notice] = @collection.title + " has been restored."
    redirect_to collections_path
  end

  def show
    @collection = Collection.find(params[:id])
  end

end
