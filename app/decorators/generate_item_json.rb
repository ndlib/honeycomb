class GenerateItemJson
  attr_reader :items, :options

  def self.call(items, options = {})
    new(items, options).to_hash
  end

  def initialize(items, options)
    @items = items
    @options = options
  end

  def to_hash
    {
      "items" => to_hash_object
    }
  end

  private
    def hash_array
      items.collect { |item| singular_hash(item) }
    end

    def singular_hash(item)
      ItemJson.new(item).to_hash(options)
    end

    def plural?
      items.respond_to?(:each)
    end

    def to_hash_object
      if plural?
        hash_array
      else
        singular_hash(items)
      end
    end

end
