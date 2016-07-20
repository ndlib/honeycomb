class Image < Media
  store_accessor :data, :image_content_type,
                        :image_file_name,
                        :image_file_size,
                        :image_fingerprint,
                        :image_meta,
                        :image_updated_at,
                        :json_response

  has_attached_file :image, restricted_characters: /[&$+,\/:;=?@<>\[\]{}\|\\^~%#]/
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  # The following methods were added to recreate the behavior of enum status:
  #   status, status=, unprocessed?, unprocessed!, processing?, processing!,
  #   ready?, ready!, unavailable?, unavailable!
  # These were added in order to resolve a conflict between store_accessor and enum.
  # They both try to add status and status= methods, so reimplementing the enum methods
  # to access the status inside of the data field
  def status=(value)
    if status_enum.has_key?(value) || value.blank?
      data["status"] = status_enum[value]
    elsif status_enum.has_value?(value)
      data["status"] = value
    else
      raise ArgumentError, "'#{value}' is not a valid status"
    end
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
