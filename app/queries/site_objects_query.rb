class SiteObjectsQuery
  # Gets an array of all of the objects referenced by site_path
  def all(collection:)
    site_path_json(collection_id: collection.id).map do |site_object|
      get_object(site_object: site_object)
    end
  end

  # Determines if an object exists in site_path for its collection
  def exists?(collection_object:)
    type = collection_object.class.name
    id = collection_object.id
    site_path_json(collection_id: collection_object.collection_id).detect do |site_object|
      if site_object[:type] == type && site_object[:id] == id
        return true
      end
    end
    false
  end

  # Looks up all id's in a json string by unique id and converts to internal ids
  # Ex:
  #   [{ type: "Showcase", unique_id: "abc123" },{ type: "Showcase", unique_id: "xyz890" }]
  # will become
  #   [{ type: "Showcase", id: 1 },{ type: "Showcase", id: 2 }]
  def public_to_private_json(json_string:)
    site_path = JSON.parse(json_string, symbolize_names: true)
    site_path.map do |site_object|
      object = get_object_public(site_object: site_object)
      { type: object.class.name, id: object.id }
    end.to_json
  end

  # Given an object within the collection, this will find the next one in the list
  def next(collection_object:)
    type = collection_object.class.name
    id = collection_object.id
    site_path_json(collection_id: collection_object.collection_id).each_cons(2) do |site_object, next_site_object|
      if site_object[:type] == type && site_object[:id] == id
        return get_object(site_object: next_site_object)
      end
    end
    nil
  end

  # Given an object within the collection, this will find the previous one in the list
  def previous(collection_object:)
    previous = nil
    type = collection_object.class.name
    id = collection_object.id
    site_path_json(collection_id: collection_object.collection_id).each do |site_object|
      if site_object[:type] == type && site_object[:id] == id
        return previous.nil? ? nil : get_object(site_object: previous)
      end
      previous = site_object
    end
    nil
  end

  private

  attr_reader :collection

  # Returns an array of hashes of the form { :type, :id }
  # Ex: [{type: "showcase", id: 3},{ type: "showcase", id:1 }]
  def site_path_json(collection_id:)
    collection = Collection.find(collection_id)
    if collection.nil? || collection.site_path.blank?
      []
    else
      JSON.parse(collection.site_path, symbolize_names: true)
    end
  end

  # Gets an object by its unique_id instead of id
  def get_object_public(site_object:)
    if supported_types.include?(site_object[:type])
      site_object[:type].constantize.find_by!(unique_id: site_object[:unique_id])
    else
      raise "Unsupported object type #{site_object[:type]}."
    end
  end

  def get_object(site_object:)
    if supported_types.include?(site_object[:type])
      site_object[:type].constantize.find(site_object[:id])
    else
      raise "Unsupported object type #{site_object[:type]}."
    end
  end

  def supported_types
    ["Showcase", "Page"]
  end
end
