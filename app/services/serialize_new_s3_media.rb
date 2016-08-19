class SerializeNewS3Media
  def self.to_hash(media:)
    result = SerializeMedia.to_hash(media: media)
    result[:upload_url] = AllocateS3Url.presigned_url(media.uuid, media.file_name)
    result
  end

  def self.to_json(media:)
    to_hash(media: media).to_json
  end
end
