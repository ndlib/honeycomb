class GenerateCollectionJson
  attr_reader :collections, :options

  def self.call(collections, options = {})
    new(collections, options).to_hash
  end

  def initialize(collections, options)
    @collections = collections
    @options = options
  end

  def to_hash
    {
      "collections" => to_hash_object
    }
  end

  private
    def hash_array
      collections.collect { |collection| singular_hash(collection) }
    end

    def singular_hash(collection)
      CollectionJson.new(collection).to_hash(options)
    end

    def plural?
      collections.respond_to?(:each)
    end

    def to_hash_object
      if plural?
        hash_array
      else
        singular_hash(collections)
      end
    end

end
