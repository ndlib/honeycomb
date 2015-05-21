class ItemDecorator < Draper::Decorator
  delegate_all

  def is_parent?
    object.parent_id.nil?
  end

  def recent_children
    ItemsDecorator.new(children_query_recent)
  end

  def image_name
    if object.honeypot_image
      object.honeypot_image.name
    else
      nil
    end
  end

  def status_text
    if object.honeypot_image
      status_text_span(className: "text-success", icon: "ok", text: h.t("status.complete"))
    else
      status_text_span(className: "text-info", icon: "minus", text: h.t("status.processing"))
    end
  end

  def status_text_span(className:, icon:, text:)
    h.content_tag("span", class: className) do
      h.content_tag("i", "", class: "glyphicon glyphicon-#{icon}") + " " + text
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
    h.react_component "ItemShowImageBox", image: image_json, thumbnailSrc: thumbnail_url, itemID: object.id.to_s
  end

  def item_meta_data_form
    h.react_component(
      "ItemMetaDataForm",
      authenticityToken: h.form_authenticity_token,
      url: h.v1_item_path(object.unique_id),
      method: "put",
      data: {
        name: object.name,
        description: object.description,
        transcription: object.transcription,
        manuscript_url: object.manuscript_url,
        creator: object.creator,
        alternate_name: object.alternate_name,
        rights: object.rights,
        original_language: object.original_language,
      })
  end

  def showcases_json
    json_string = h.render :partial => "showcases/showcases", formats: [:json], locals: { showcases: object.showcases }
    if json_string
      ActiveSupport::JSON.decode(json_string)
    else
      {}
    end
  end

  def edit_path
    h.edit_item_path(object.id)
  end

  def page_name
    h.render partial: "/items/item_name", locals: { item: self }
  end

  def thumbnail_url
    if object.image.exists?(:thumb)
      object.image.url(:thumb)
    else
      return nil
    end
  end

  def thumbnail
    h.react_component("Thumbnail", image: image_json, thumbnailSrc: thumbnail_url)
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
