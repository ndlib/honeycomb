class GenerateItemJson
  attr_reader :items, :options

  def self.call(items, options = {})
    new(items, options).to_hash
  end

  def initialize(items, options)
    @options = options
    @items = items
  end

  def to_hash
    {
      "items" => json_is_collection? ? collection_json : item_json_hash(items)
    }
  end

  private

    def json_is_collection?
      items.respond_to?(:each)
    end

    def collection_json
      items.collect { | item | item_json_hash(item) }
    end

    def item_json_hash(item)
      ItemJson.new(item).to_hash(options)
    end

end
