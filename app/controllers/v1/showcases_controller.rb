module V1
  class ShowcasesController < APIController

    def index
      @collection = CollectionJSONDecorator.new(CollectionQuery.new.public_find(params[:collection_id]))
    end

    def show
      @showcase = ShowcaseJSONDecorator.new(ShowcaseQuery.new.public_find(params[:id]))
    end
  end
end
