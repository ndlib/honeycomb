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
    media.status = :ready
    media.save
    media.serializer = SerializeMedia

    media
  end
end
