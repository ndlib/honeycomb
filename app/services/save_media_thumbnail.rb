class SaveMediaThumbnail
  attr_reader :image, :item, :media

  def self.call(*args)
    new(*args).save!
  end

  def initialize(image:, item:, media:)
    @image = image
    @item = item
    @media = media
  end

  def save!
    @image_response = send_image_request
    return false unless @image_response
    if update_media_record
      true
    else
      false
    end
  end

  private

  def send_image_request
    response = image_server_connection.post("/api/images", image_post)
    if response.success?
      response
    else
      false
    end
  end

  def update_media_record
    media.thumbnail_url = @image_response.body["thumbnail/medium"]["contentUrl"]
    media_response = BuzzMedia.call_update(media: media)
    if media_response
      media.data["json_response"] = media_response
      media.save!
    else
      false
    end
  end

  def image_server_connection
    @image_server_connection ||= Faraday.new(image_server_url) do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http
      f.response :json, content_type: "application/json"
    end
  end

  def upload_image
    Faraday::UploadIO.new(image.path, "image")
  end

  def image_post
    { application_id: "honeycomb", group_id: item.collection.id, item_id: item.id, image: upload_image }
  end

  def image_server_url
    Rails.configuration.settings.image_server_url
  end
end
