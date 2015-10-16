class Exhibition
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Callbacks

  validates :name_line_1, presence: true

  collection_methods = [
    :items,
    :name_line_1,
    :name_line_2,
    :unique_id,
    :showcases,
    :description,
    :about,
    :published,
    :preview_mode,
    :copyright,
    :short_intro,
    :site_intro,
    :updated_at,
    :image,
    :honeypot_image,
    :uploaded_image,
    :hide_title_on_home_page,
    :showcases,
    :url
  ]
  exhibit_methods = [
  ]

  delegate *collection_methods, to: :collection
  delegate *exhibit_methods, to: :exhibit

  collection_methods.each do |method|
    delegate (method.to_s + "=").to_sym, to: :collection
  end

  exhibit_methods.each do |method|
    delegate (method.to_s + "=").to_sym, to: :exhibit
  end

  def self.all
    ExhibitQuery.new.all_external.map { |exhibit| new(exhibit: exhibit) }
  end

  def initialize(exhibit: self.exhibit)
    @exhibit = exhibit
    @collection = collection
    # collection.exhibit = @exhibit
  end

  def external?
    if !@collection.url.blank?
      return true
    end
    false
  end

  def full_name
    collection.name
  end

  def collection
    @collection ||= get_collection
  end

  def save!
    ActiveRecord::Base.transaction do
      # exhibit.collection = collection
      if collection.uploaded_image.size
        collection_attrs = collection.as_json.merge(uploaded_image: collection.uploaded_image)
      else
        collection_attrs = collection.as_json
      end
      SaveCollection.call(collection, collection_attrs)
      # SaveExhibit.call(exhibit, exhibit.as_json)
    end
  end
  # rubocop:enable Metrics/AbcSize

  def exhibit
    @exhibit ||= Exhibit.new
  end

  def persisted?
    false
  end

  private

  def get_collection
    if !@exhibit.id.blank?
      @exhibit.collection
    else
      Collection.new
    end
  end
end
