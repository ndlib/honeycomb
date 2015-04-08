require 'draper'

class ShowcasePublishAction < Draper::Decorator

  def self.display(item)
    self.new(item).display
  end

  def display
    h.react_component('ShowcasePublishAction', component_parameters)
  end

  private

  def i18n_key_base
    @base ||= "items.edit"
  end

  def component_parameters
    {
      published: !!object.published,
      publishPath: h.publish_showcase_path(object.id),
      unpublishPath: h.unpublish_showcase_path(object.id),
      publishPanelFieldName: h.t("#{i18n_key_base}.publish_field"),
    }
  end
end
