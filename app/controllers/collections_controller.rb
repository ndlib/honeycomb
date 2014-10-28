class CollectionsController < ApplicationController

  def index
    @collections = Collection.all
  end

  def new
    @collection = Collection.new
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

  def show
    @collection = Collection.find(params[:id])
  end

end
