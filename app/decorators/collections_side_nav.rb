class CollectionsSideNav < Draper::Decorator
  attr_reader :collection, :form

  def initialize(collection:, form:)
    @collection = collection
    @form = form
  end

  def homepage_link
    h.link_to("Homepage", h.site_setup_form_collection_path(collection, form: "homepage"))
  end

  def collection_introduction_link
    h.link_to("Introduction", h.site_setup_form_collection_path(collection, form: "collection_introduction"))
  end

  def copyright_text_link
    h.link_to("Copyright", h.site_setup_form_collection_path(collection, form: "copyright_text"))
  end

  def about_text_link
    h.link_to("About", h.site_setup_form_collection_path(collection, form: "about_text"))
  end

  def site_path_link
    h.link_to("Site Path", h.site_setup_form_collection_path(collection, form: "site_path"))
  end

  def active_tab_class(tab:)
    return "active" if tab == form
    return "active" if tab == "homepage" && form.nil?
    ""
  end
end
