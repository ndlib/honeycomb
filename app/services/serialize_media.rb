# Currently serializes all media types. Assumes that media has a json_response.
# If these ever need to diverge from simply rendering the media.json_response,
# we should create separate service classes for each
class SerializeMedia
  def self.to_hash(media:)
    result = { uuid: media.uuid, file_name: media.file_name, media_type: media.type.downcase }
    result.merge!(media.json_response) if media.json_response
    result.merge!(media.errors.to_hash) if media.errors
  end

  def self.to_json(media:)
    to_hash(media: media).to_json
  end
end
