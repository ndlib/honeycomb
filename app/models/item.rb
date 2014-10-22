class Item < ActiveRecord::Base
  belongs_to :collection

  has_attached_file :image, :preserve_files => true
 #, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  validates :title, :collection, presence: true
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/


end
