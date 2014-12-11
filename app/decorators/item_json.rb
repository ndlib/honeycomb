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
        manuscript_url: object.manuscript_url,
      }
    end

    def collection_data
      {
        id: object.collection.id,
        title: object.collection.title
      }
    end

    def image_data
      if object.honeypot_image.present?
        object.honeypot_image.image_json
      else
        {}
      end
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

      if options && options[:include] && options[:include].include?('image')
        links[:image] = image_data
      end
      links
    end
end
