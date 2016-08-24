# Currently serializes all Audio/Video media types since they all have the same attributes.
# If these ever need to diverge and have different attributes, we should create
# separate service classes for each
class SerializeAVMedia
  def self.to_hash(media:)
    result = {
      "@context" => "http://schema.org",
      "@id" => media.uuid,
      name: media.file_name,
      "@type" => at_type(media: media),
      status: status(media: media)
    }
    # This assumes the external service is rendering the same type of objects
    # (AudioObject, VideoObject, ImageObject). So, the attributes from that service
    # (contained in json_response) can simply be added to the media object's attributes
    result = media.json_response.merge(result) if media.json_response
    result.merge!(media.errors.to_hash) if media.errors
    unless result[:thumbnailUrl].present?
      result[:thumbnailUrl] = default_thumbnail(media: media)
    end
    result
  end

  def self.to_json(media:)
    to_hash(media: media).to_json
  end

  # Converts from media subclass to @type
  # So far, all of our objects map as follows:
  #   Audio => AudioObject
  #   Video => VideoObject
  #   Image => ImageObject
  def self.at_type(media:)
    "#{media.type}Object"
  end

  # Maps internal state system for media.status to a simple "ready|not ready|error"
  # status, which is generally sufficient info for API consumers
  def self.status(media:)
    case media.status
    when "allocated"
      "not ready"
    when "ready"
      "ready"
    else
      "error"
    end
  end

  def self.default_thumbnail(media:)
    image_name = "medium/default-#{media.type.downcase}-thumbnail.jpg"
    URI.join(Rails.application.routes.url_helpers.root_url, ActionController::Base.helpers.image_url(image_name)).to_s
  end

  private_class_method :at_type
  private_class_method :status
end
