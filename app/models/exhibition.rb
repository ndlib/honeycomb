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
    :exhibit,
    :description,
    :about,
    :published,
    :preview_mode,
    :updated_at
  ]
  exhibit_methods = [
    :image,
    :name,
    :honeypot_image,
    :uploaded_image,
    :showcases,
    :copyright,
    :hide_title_on_home_page,
    :short_description,
    :url
  ]

  delegate *collection_methods, to: :collection
  delegate *exhibit_methods, to: :exhibit

  collection_methods.each do |method|
    delegate (method.to_s + "=").to_sym, to: :collection
  end

  exhibit_methods.each do |method|
    delegate (method.to_s + "=").to_sym, to: :exhibit
  end

  def self.by_collection_id(collection_id)
    new(exhibit: CollectionQuery.new.public_find(collection_id).exhibit)
  end

  def self.all
    ExhibitQuery.new.all_external.map { |exhibit| new(exhibit: exhibit) }
  end

  def initialize(exhibit: self.exhibit)
    @exhibit = exhibit
    @collection = collection
    collection.exhibit = @exhibit
  end

  def external?
    if !@exhibit.url.blank?
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

  # rubocop:disable Metrics/AbcSize
  def save!
    ActiveRecord::Base.transaction do
      SaveCollection.call(collection, collection.as_json)
      exhibit.collection = collection
      if exhibit.uploaded_image.size
        exhibit_attrs = exhibit.as_json.merge(uploaded_image: exhibit.uploaded_image)
      else
        exhibit_attrs = exhibit.as_json
      end
      SaveExhibit.call(exhibit, exhibit_attrs)
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
