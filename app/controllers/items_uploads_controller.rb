class ItemsUploadsController < ApplicationController

  def new

  end


  def create


  end


  protected

    def collection
      @collection ||= Collection.find(params[:collection_id])
    end


end

