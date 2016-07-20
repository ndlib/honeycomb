class Showcase < ActiveRecord::Base
  belongs_to :collection
  has_many :sections
  has_many :items, through: :sections
  belongs_to :image, class_name: "Image", foreign_key: :media_id

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
