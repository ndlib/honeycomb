class Item < ActiveRecord::Base
  has_paper_trail

  belongs_to :collection
  belongs_to :parent, class_name: "Item", foreign_key: :parent_id
  has_many :children, class_name: "Item", foreign_key: :parent_id
  has_many :sections
  has_many :showcases, -> { distinct }, through: :sections
  has_many :items_pages
  has_many :pages, through: :items_pages
  belongs_to :media

  validates :collection, :unique_id, :user_defined_id, presence: true
  validate :manuscript_url_is_valid_uri

  def name
    item_metadata.name
  end

  def description
    item_metadata.description
  end

  def item_metadata
    @item_metadata ||= Metadata::Fields.new(self)
  end

  def metadata=(_values)
    raise "Use Metadata::Setter.call instead see SaveItem"
  end
 
  private

  def manuscript_url_is_valid_uri
    if manuscript_url.present? && !URIParser.valid?(manuscript_url)
      errors.add(:manuscript_url, :invalid_url)
    end
  end
end
