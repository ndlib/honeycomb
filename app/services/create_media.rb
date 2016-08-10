# Serves as a factory for creating media subtypes
class CreateMedia
  attr_reader :owner, :collection, :params, :media

  def self.call(owner:, collection:, params:)
    new(owner, collection, params).create!
  end

  def initialize(owner, collection, params)
    @owner = owner
    @collection = collection
    @params = params
  end

  def create!
    type = params.delete(:media_type)
    case type
    # Video and audio construction are identical atm. When they diverge
    # we should probably create CreateVideo and CreateAudio service objects
    # and offload the work to those
    when "video"
      create_and_associate(type: Video)
    when "audio"
      create_and_associate(type: Audio)
    else
      @media = UnknownMedia.new(media_type: type)
      media.serializer = SerializeMedia
      media
    end
  end

  private

  def create_and_associate(type:)
    media = type.new(params.symbolize_keys)
    media.uuid = SecureRandom.uuid
    media.collection = collection
    media.status = "allocated"
    if media.save
      media.serializer = SerializeNewS3Media
      owner.media_id = media.id
      owner.save
    else
      media.serializer = SerializeMedia
    end
    media
  end
end
