module V1
  # Version 1 API
  class ImportController < APIController
    def csv
      collection = CollectionQuery.new.any_find(params[:collection_id])
      result = CsvCreateItems.call(collection: collection, file: params[:file])
      render json: result
    end
  end
end
