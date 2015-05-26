class ItemDecorator < Draper::Decorator
  delegate_all

  def is_parent?
    object.parent_id.nil?
  end

  def recent_children
    ItemsDecorator.new(children_query_recent)
  end

  def image_title
    if object.honeypot_image
      object.honeypot_image.title
    else
      nil
    end
  end

  def back_path
    if is_parent?
      h.collection_path(object.collection_id)
    else
      h.item_children_path(object.parent_id)
    end
  end

  def show_image_box
    h.react_component "ItemShowImageBox", image: image_json, itemID: object.id.to_s
  end

  def item_meta_data_form
    h.react_component(
      "ItemMetaDataForm",
      authenticityToken: h.form_authenticity_token,
      url: h.v1_item_path(object.unique_id),
      method: "put",
      data: {
        title: object.title,
        description: object.description,
        transcription: object.transcription,
        manuscript_url: object.manuscript_url,
      })
  end

  def edit_path
    h.edit_item_path(object.id)
  end

  private

  def image_json
    if object.honeypot_image
      object.honeypot_image.image_json
    else
      {}
    end
  end

  def children_query_recent
    children_query.recent(5)
  end

  def children_query
    @children_query ||= ItemQuery.new(object.children)
  end
end
