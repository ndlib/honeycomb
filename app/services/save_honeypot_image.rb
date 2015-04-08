class SaveHoneypotImage
  attr_reader :object

  def self.call(object)
    new(object).save!
  end

  def initialize(object)
    @object = object
  end

  def save!
    response = send_request

    if response && update_image_server(response)
      honeypot_image
    else
      false
    end
  end

  private

  def honeypot_image
    object.honeypot_image || object.build_honeypot_image
  end

  def update_image_server(request)
    body = request.body.with_indifferent_access
    honeypot_image.json_response = body

    honeypot_image.save
  end

  def send_request
    response = connection.post('/api/images', post)
    if response.success?
      response
    else
      false
    end
  end

  def connection
    @connection ||= Faraday.new(api_url) do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http
      f.response :json, content_type: 'application/json'
    end
  end

  def group_id
    object.collection.id
  end

  def object_id
    object.id
  end

  def object_image
    object.image
  end

  def upload_image
    Faraday::UploadIO.new(object_image.path, object_image.content_type)
  end

  def post
    { application_id: 'honeycomb', group_id: group_id, item_id: object_id, image: upload_image }
  end

  def api_url
    Rails.configuration.settings.honeypot_url
  end
end
