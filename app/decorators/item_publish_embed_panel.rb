require 'draper'

class ItemPublishEmbedPanel < Draper::Decorator
  def self.display(item)
    new(item).display
  end

  def display
    h.react_component('ItemPublishEmbedPanel', component_parameters)
  end

  private

  def i18n_key_base
    @base ||= 'items.edit'
  end

  def component_parameters
    {
      item: object,
      embedBaseUrl: Rails.configuration.settings.beehive_url,
      publishPanelTitle: h.t("#{i18n_key_base}.publish"),
      publishPanelHelp: h.t("#{i18n_key_base}.publish_help"),
      publishPanelFieldName: h.t("#{i18n_key_base}.publish_field"),
      embedPanelTitle: h.t("#{i18n_key_base}.embed"),
      embedPanelHelp: h.t("#{i18n_key_base}.embed_help"),
      published: !!object.published,
      publishPath: h.publish_item_path(object.id),
      unpublishPath: h.unpublish_item_path(object.id)
    }
  end
end
