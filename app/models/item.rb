class Item < ActiveRecord::Base
  store :metadata, accessors: [:creator, :publisher, :alternate_name, :rights, :original_language], coder: JSON

  has_paper_trail

  belongs_to :collection
  belongs_to :parent, class_name: "Item", foreign_key: :parent_id
  has_many :children, class_name: "Item", foreign_key: :parent_id
  has_many :sections
  has_many :showcases, -> { distinct }, through: :sections
  has_one :honeypot_image

  has_attached_file :image,
                    restricted_characters: /[&$+,\/:;=?@<>\[\]{}\|\\^~%#]/,
                    styles: lambda {|a| a.instance.image_styles(a)}

  validates :name, :collection, presence: true
  validates :image, attachment_presence: true

  validate :manuscript_url_is_valid_uri

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def image_styles(attachment)
    if @image_styles.nil?
      @image_styles = {
        original: "16000000@",
        thumb: "300x300>",
        section: "x800>"
      }
      if self.image_content_type == "image/tiff"
        @image_styles.each do |key, value|
          @image_styles[key] = [value, :jpg]
        end
      end
    end
    @image_styles
  end

  private

  def manuscript_url_is_valid_uri
    if manuscript_url.present? && !URIParser.valid?(manuscript_url)
      errors.add(:manuscript_url, :invalid_url)
    end
  end
end
