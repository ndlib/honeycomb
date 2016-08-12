# Currently serializes all media types since they all have the same attributes.
# If these ever need to diverge and have different attributes, we should create
# separate service classes for each
class SerializeMedia
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
  end

  def self.to_json(media:)
    to_hash(media: media).to_json
  end

  private

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
end
