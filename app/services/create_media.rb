# Serves as a factory for creating media subtypes
class CreateMedia
  attr_reader :collection, :params, :media

  def self.call(collection:, params:)
    new(collection, params).create!
  end

  def initialize(collection, params)
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
        media = Video.new(param_syms, collection: collection, uuid: SecureRandom.uuid)
        media.collection = collection
        media.serializer = media.save ? SerializeNewS3Media : SerializeMedia
        media
      when "audio"
        media = Audio.new(param_syms, collection: collection, uuid: SecureRandom.uuid)
        media.collection = collection
        media.serializer = media.save ? SerializeNewS3Media : SerializeMedia
        media
      else
        media = Media.new(collection: collection)
        media.serializer = SerializeUnknownMedia
        media
    end
  end
end
