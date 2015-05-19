class Item < ActiveRecord::Base
  has_paper_trail

  belongs_to :collection
  belongs_to :parent, class_name: "Item", foreign_key: :parent_id
  has_many :children, class_name: "Item", foreign_key: :parent_id
  has_one :honeypot_image

  has_attached_file :image, restricted_characters: /[&$+,\/:;=?@<>\[\]{}\|\\^~%#]/
  # , :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  # Alias old title field to name until other service objects get changed,
  # ex: CreateBeehiveURL is used on multiple objects and expects a title attr
  alias_attribute :title, :name

  validates :name, :collection, presence: true
  validates :image, attachment_presence: true

  validate :manuscript_url_is_valid_uri

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def beehive_url
    CreateBeehiveURL.call(self)
  end

  private

  def manuscript_url_is_valid_uri
    if manuscript_url.present? && !URIParser.valid?(manuscript_url)
      errors.add(:manuscript_url, :invalid_url)
    end
  end
end
