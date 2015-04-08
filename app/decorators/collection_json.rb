class CollectionJSON < Draper::Decorator

  def to_json(options = {})
    to_hash(options).to_json
  end

  def to_hash(options = {})
    collection_data
  end

  private

    def collection_data
      {
        id: object.id,
        title: object.title,
      }
    end
end
