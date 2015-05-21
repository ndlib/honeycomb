class CollectionJSON < Draper::Decorator
  def to_json(options = {})
    to_hash(options).to_json
  end

  def to_hash(_options = {})
    collection_data
  end

  private

  def collection_data
    {
      id: object.id,
      name_line_1: object.name_line_1
    }
  end
end
