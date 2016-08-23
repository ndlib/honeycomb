# Serves as a factory for creating media subtypes
class FinishMediaUpload
  attr_reader :media

  def self.call(media:)
    new(media: media).finish!
  end

  def initialize(media:)
    @media = media
  end

  def finish!
    result = BuzzMedia.call_create(media: media)
    if result
      media.json_response = result
      media.status = :ready
      media.save
    end

    media.serializer = SerializeMedia
    media
  end
end
