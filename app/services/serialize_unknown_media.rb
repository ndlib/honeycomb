class SerializeUnknownMedia
  def self.to_hash(media:)
    {
      error: [
        {
            name: "media_type",
            description: "Unknown media type"
        }
      ]
    }
  end

  def self.to_json(media:)
    to_hash(media: media).to_json
  end
end
