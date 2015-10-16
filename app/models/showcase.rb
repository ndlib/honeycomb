class Showcase < ActiveRecord::Base
  belongs_to :collection
  has_many :sections
  has_many :items, through: :sections
  has_one :honeypot_image

  has_attached_file :image,
                    restricted_characters: /[&$+,\/:;=?@<>\[\]{}\|\\^~%#]/
  has_attached_file :uploaded_image,
                    restricted_characters: /[&$+,\/:;=?@<>\[\]{}\|\\^~%#]/

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_attachment_content_type :uploaded_image, content_type: /\Aimage\/.*\Z/

  validates :name_line_1, :collection, :unique_id, presence: true

  has_paper_trail

  def slug
    name_line_1
  end

  def name
    if name_line_2.present?
      "#{name_line_1} #{name_line_2}"
    else
      name_line_1
    end
  end

  def beehive_url
    CreateBeehiveURL.call(self)
  end
end
