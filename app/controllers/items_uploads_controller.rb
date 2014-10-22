class ItemsUploadsController < ApplicationController

  def new
    @item = collection.items.build
  end


  def create


  end


  protected

    def collection
      @collection ||= Collection.find(params[:collection_id])
    end


end

