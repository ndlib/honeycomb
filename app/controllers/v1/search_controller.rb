module V1
  class SearchController < APIController
    def index
      search_arguments = {
        q: params[:q],
        facets: params[:facets],
        sort: params[:sort],
        rows: params[:rows],
        start: params[:start],
        filters: { collection_id: collection.unique_id },
        collection: collection,
      }
      @search = Waggle.search(**search_arguments)
    end

    def children
      group_by = params[:no_group] ? nil : "part_parent_s"

      search_arguments = {
        q: "-part_parent_s:_is_parent_ " + (params[:q] ? "AND " + params[:q] : ""),
        facets: params[:facets],
        sort: params[:sort],
        rows: params[:rows],
        start: params[:start],
        filters: { collection_id: collection.unique_id },
        group_by: group_by,
        collection: collection,
      }
      @search = Waggle.search(**search_arguments)
    end

    private

    def collection
      if params[:collection_id]
        CollectionQuery.new.any_find(params[:collection_id])
      end
    end
  end
end
