class ItemJson < Draper::Decorator

  def to_json(options = {})
    to_hash(options).to_json
  end

  def to_hash(options = {})
    data = item_data
    data[:links] = add_links(options)

    data
  end

  private
    def include_array(options = {})
      include_options = []
      if options && options[:include]
        if options[:include].is_a?(String)
          include_options = options[:include].split(',')
        elsif options[:include].is_a?(Array)
          include_options = options[:include]
        end
      end
      include_options.collect{|s| s.to_s.strip}
    end

    def include?(options, value)
      include_array(options).include?(value.to_s)
    end

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
        nil
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
      if include?(options, :collection)
        links[:collection] = collection_data
      end

      if include?(options, :image)
        links[:image] = image_data
      end
      links
    end
end
