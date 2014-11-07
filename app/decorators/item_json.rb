class ItemJson < Draper::Decorator

  def to_json(options = {})
    data = item_data
    data[:links] = add_links(options)

    data.to_json
  end

  private

    def item_data
      {
        id: object.id,
        title: object.title,
        description: object.description,
        updated_at: object.updated_at,
      }
    end

    def collection_data
      {
        id: object.collection.id,
        title: object.collection.title
      }
    end

    def tiled_image_data
      return {} if object.tiled_image.nil?
      {
        id: object.tiled_image.id,
        uri: object.tiled_image.uri,
        width: object.tiled_image.width,
        height: object.tiled_image.height,
      }
    end


    def add_links(options ={})
      links = {}
      if options && options[:include] && options[:include].include?('collection')
        links[:collection] = collection_data
      end

      if options && options[:include] && options[:include].include?('tiled_image')
        links[:tiled_image] = tiled_image_data
      end
      #links[:tiled_image] = tiled_image_data
      links
    end
end
