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
    param_syms = params.symbolize_keys
    case type
      # Video and audio construction are identical atm. When they diverge
      # we should probably create CreateVideo and CreateAudio service objects
      # and offload the work to those
      when "video"
        @media = Video.new(param_syms, collection: collection, uuid: SecureRandom.uuid)
        save_and_associate
        media
      when "audio"
        @media = Audio.new(param_syms, collection: collection, uuid: SecureRandom.uuid)
        save_and_associate
        media
      else
        @media = UnknownMedia.new(media_type: type)
        media.serializer = SerializeMedia
        media
    end
  end

  private

  def save_and_associate
    media.collection = collection
    if media.save
      media.serializer = SerializeNewS3Media
      owner.media_id = media.id
      owner.save
    else
      media.serializer = SerializeMedia
    end
  end
end
