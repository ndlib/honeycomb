class Image < ActiveRecord::Base
  serialize :json_response, Hash

  belongs_to :collection
  has_many :items
  has_attached_file :image, restricted_characters: /[&$+,\/:;=?@<>\[\]{}\|\\^~%#]/

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates :collection, presence: true

  enum status: { unprocessed: 0, processing: 1, ready: 2, unavailable: 3 }

  has_paper_trail
end
