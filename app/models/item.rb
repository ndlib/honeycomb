class Item < ActiveRecord::Base
  has_paper_trail

  belongs_to :collection
  has_one :tiled_image

  has_attached_file :image
 #, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  validates :title, :collection, presence: true
  validates :image, attachment_presence: true

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
