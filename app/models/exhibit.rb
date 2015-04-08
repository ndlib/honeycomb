class Exhibit < ActiveRecord::Base
  has_many :showcases
  belongs_to :collection
  has_one :honeypot_image

  has_attached_file :image, restricted_characters: /[&$+,\/:;=?@<>\[\]{}\|\\^~%#]/
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def items_json_url
    "/api/collections/#{collection_id}/items.json?include=image"
  end

  def item_json_url(item_id)
    "/api/collections/#{collection_id}/items/#{item_id}.json?include=image"
  end
end
