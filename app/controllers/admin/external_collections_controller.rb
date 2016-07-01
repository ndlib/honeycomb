module Admin
  class ExternalCollectionsController < ApplicationController
    def index
      check_admin_or_admin_masquerading_permission!
      @external_collections = CollectionQuery.new.all_external
    end

    def new
      check_admin_or_admin_masquerading_permission!
      @form_action = admin_external_collections_path
      @external_collection = CollectionQuery.new.build
    end

    def create
      check_admin_or_admin_masquerading_permission!

      @external_collection = CollectionQuery.new.build(published: true)
      if SaveCollection.call(external_collection, save_params)
        flash[:notice] = t(".success")
        redirect_to admin_external_collections_path
      else
        render :new
      end
    end

    def edit
      check_admin_or_admin_masquerading_permission!
      @external_collection = CollectionQuery.new.find(params[:id])
      @form_action = admin_external_collection_path(external_collection)
      @image = external_collection.image[:json_response]["thumbnail/small"]["contentUrl"] if external_collection.image
    end

    def update
      check_admin_or_admin_masquerading_permission!
      @external_collection = CollectionQuery.new.find(params[:id])

      if SaveCollection.call(@external_collection, save_params)
        flash[:notice] = t(".success")
        redirect_to edit_admin_external_collection_path(@external_collection)
      else
        render :edit
      end
    end

    def destroy
      check_admin_or_admin_masquerading_permission!

      @external_collection = CollectionQuery.new.find(params[:id])
      Destroy::Collection.new.cascade!(collection: external_collection)

      flash[:notice] = t(".success")
      redirect_to admin_external_collections_path
    end

    private

    attr_reader :external_collection

    def save_params
      params.require(:external_collection).permit(
        :name_line_1,
        :about,
        :id,
        :url,
        :uploaded_image,
        :published)
    end
  end
end
