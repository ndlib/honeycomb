module V1
  # Version 1 API
  class ImportController < APIController
    def csv
      collection = CollectionQuery.new.any_find(params[:collection_id])
      return if rendered_forbidden?(collection)

      result = CsvCreateItems.call(collection: collection, file: params[:csv_file])
      render json: result
    end
  end
end
