require "store_enum"

class Image < Media
  store_accessor :data,
                 :image_content_type,
                 :image_file_name,
                 :image_file_size,
                 :image_fingerprint,
                 :image_meta,
                 :image_updated_at,
                 :json_response
  extend StoreEnum
  store_enum :data, status: { unprocessed: 0, processing: 1, ready: 2, unavailable: 3 }

  has_attached_file :image, restricted_characters: /[&$+,\/:;=?@<>\[\]{}\|\\^~%#]/
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
