class SerializeImageMedia
  def self.to_hash(media:)
    result = {}
    result["@context"] = "http://schema.org"
    result["@type"] = "ImageObject"
    result["@id"] = url(media: media, style: :large)
    result["name"] = media.image.original_filename
    result["thumbnailUrl"] = url(media: media, style: :medium)
    result["status"] = status(media: media)
    result = media.json_response.merge(result)
    result
  end

  def self.to_json(media:)
    to_hash(media: media).to_json
  end

  def self.url(media:, style: :original)
    if media.json_response["thumbnail/#{style}"]
      media.json_response["thumbnail/#{style}"]["contentUrl"]
    else
      media.json_response["contentUrl"]
    end
  end

  # Maps internal state system for media.status to a simple "ready|not ready|error"
  # status, which is generally sufficient info for API consumers
  def self.status(media:)
    case media.status
    when "unprocessed", "processing"
      "not ready"
    when "ready"
      "ready"
    else
      "error"
    end
  end

  private_class_method :url
  private_class_method :status
end
