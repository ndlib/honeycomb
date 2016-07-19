class Image < ActiveRecord::Base
  store_accessor :data, :image_content_type,
                        :image_file_name,
                        :image_file_size,
                        :image_fingerprint,
                        :image_meta,
                        :image_updated_at,
                        :json_response

  belongs_to :collection
  has_many :items
  has_attached_file :image, restricted_characters: /[&$+,\/:;=?@<>\[\]{}\|\\^~%#]/

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates :collection, presence: true

  def status=(name)
    data["status"] = status_enum[name]
  end

  def status
    status_enum.key data["status"]
  end

  def default_status
    "unprocessed"
  end

  def unprocessed?
    data["status"] == status_enum["unprocessed"]
  end

  def unprocessed!
    data["status"] = status_enum["unprocessed"]
  end

  def processing?
    data["status"] == status_enum["processing"]
  end

  def processing!
    data["status"] = status_enum["processing"]
  end

  def ready?
    data["status"] == status_enum["ready"]
  end

  def ready!
    data["status"] = status_enum["ready"]
  end

  def unavailable?
    data["status"] == status_enum["unavailable"]
  end

  def unavailable!
    data["status"] = status_enum["unavailable"]
  end

  has_paper_trail

  private

  def status_enum
    { "unprocessed" => 0, "processing" => 1, "ready" => 2, "unavailable" => 3 }
  end
end
