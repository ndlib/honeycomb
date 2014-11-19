class ItemJson < Draper::Decorator

  def to_json(options = {})
    to_hash.to_json(options)
  end

  def to_hash(options = {})
    data = item_data
    data[:links] = add_links(options)

    data
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
        host: object.tiled_image.host,
        path: object.tiled_image.path,
        width: object.tiled_image.width,
        height: object.tiled_image.height,
      }
    end

    def parent_data
      object.parent_id
    end

    def children_data
      object.child_ids
    end


    def add_links(options ={})
      links = {}
      links[:parent] = parent_data
      links[:children] = children_data
      if options && options[:include] && options[:include].include?('collection')
        links[:collection] = collection_data
      end

      if options && options[:include] && options[:include].include?('tiled_image')
        links[:tiled_image] = tiled_image_data
      end
      links
    end
end
