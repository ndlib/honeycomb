require "draper"

class ReindexPanel < Draper::Decorator
  attr_accessor :path

  def display()
    yield(self) if block_given?

    h.render partial: "shared/reindex_panel", locals: { default_name: default_name, path: path, i18n_key_base: i18n_key_base }
  end

  def default_name
    object.class.to_s
  end

  def path
    @path || h.url_for(object) + '/reindex'
  end

  def i18n_key_base
    "#{object.class.to_s.downcase.pluralize}.reindex_panel"
  end
end
