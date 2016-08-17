class SaveHoneypotImage
  attr_reader :image, :image_field

  def self.call(*args)
    new(*args).save!
  end

  def initialize(image:, image_field: "image")
    @image = image
    @image_field = image_field
  end

  def save!
    pre_save
    response = send_request
    if response && update_image_response(response)
      post_save
      image
    else
      false
    end
  end

  private

  def update_image_response(request)
    body = request.body.with_indifferent_access
    image.json_response = body
    image.save
  end

  # Anything that needs to be done before saving
  def pre_save
    image.status = "ready"
  end

  # Anything that needs to be done after a successful save
  def post_save
    image.items.each do |item|
      Index::Item.index!(item)
    end
  end

  def send_request
    response = connection.post("/api/images", post)
    if response.success?
      response
    else
      false
    end
  end

  def connection
    @connection ||= Faraday.new(image_server_url) do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http
      f.response :json, content_type: "application/json"
    end
  end

  def object_image
    image.send(image_field)
  end

  def upload_image
    Faraday::UploadIO.new(object_image.path, object_image.content_type)
  end

  def post
    { application_id: "honeycomb", group_id: image.collection.id, item_id: image.id, image: upload_image }
  end

  def image_server_url
    Rails.configuration.settings.image_server_url
  end
end
