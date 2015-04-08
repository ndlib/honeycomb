class Showcase < ActiveRecord::Base
  belongs_to :exhibit
  has_one :collection, through: :exhibit
  has_many :sections
  has_one :honeypot_image

  has_attached_file :image, :restricted_characters => /[&$+,\/:;=?@<>\[\]{}\|\\^~%#]/
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  validates :title, :exhibit, presence: true
  validates :image, attachment_presence: true

  has_paper_trail

  def beehive_url
    CreateBeehiveURL.call(self)
  end
  has_paper_trail

end

