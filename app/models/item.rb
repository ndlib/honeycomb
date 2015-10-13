class Item < ActiveRecord::Base
  store :metadata,
        accessors: [
          :creator,
          :contributor,
          :publisher,
          :alternate_name,
          :rights,
          :call_number,
          :provenance,
          :subject,
          :original_language,
          :date_created,
          :date_published,
          :date_modified
        ], coder: JSON

  has_paper_trail

  belongs_to :collection
  belongs_to :parent, class_name: "Item", foreign_key: :parent_id
  has_many :children, class_name: "Item", foreign_key: :parent_id
  has_many :sections
  has_many :showcases, -> { distinct }, through: :sections
  has_one :honeypot_image

  has_attached_file :image,
                    restricted_characters: /[&$+,\/:;=?@<>\[\]{}\|\\^~%#]/,
                    styles: {
                      thumb: "300x300>",
                      section: "x800>"
                    }

  has_attached_file :uploaded_image,
                    restricted_characters: /[&$+,\/:;=?@<>\[\]{}\|\\^~%#]/

  validates :name, :collection, :unique_id, :user_defined_id, presence: true
  validates :date_created, :date_modified, :date_published, date: true
  validate :manuscript_url_is_valid_uri

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_attachment_content_type :uploaded_image, content_type: /\Aimage\/.*\Z/

  enum image_status: { image_invalid: 0, image_processing: 1, image_ready: 2, no_image: 3 }

  private

  def manuscript_url_is_valid_uri
    if manuscript_url.present? && !URIParser.valid?(manuscript_url)
      errors.add(:manuscript_url, :invalid_url)
    end
  end
end
