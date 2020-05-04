class ReindexCollectionJob < ActiveJob::Base
  queue_as :honeycomb_index

  def perform(collection_id:)
    collection = Collection.find(collection_id)

    Index::Collection.index!(collection: collection)
  end
end
