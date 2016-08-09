# Currently serializes all media types. Assumes that media has a json_response.
# If these ever need to diverge from simply rendering the media.json_response,
# we should create separate service classes for each
class SerializeMedia
  def self.to_hash(media:)
    media.json_response || media.errors.to_hash
  end

  def self.to_json(media:)
    to_hash(media: media).to_json
  end
end
