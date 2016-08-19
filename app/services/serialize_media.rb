class SerializeMedia
  def self.to_hash(media:)
    case media.type
    when "Image"
      SerializeImageMedia.to_hash(media: media)
    else
      result = SerializeAVMedia.to_hash(media: media)
      result
    end
  end

  def self.to_json(media:)
    to_hash(media: media).to_json
  end
end
