class SaveHoneypotImage
  attr_reader :item

  def self.call(item)
    new(item).save!
  end

  def initialize(item)
    @item = item
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
      item.honeypot_image || item.build_honeypot_image
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
        f.response :json, :content_type => 'application/json'
      end
    end

    def group_id
      item.collection_id
    end

    def item_id
      item.id
    end

    def item_image
      item.image
    end

    def upload_image
      Faraday::UploadIO.new(item_image.path, item_image.content_type)
    end

    def post
      { application_id: "honeycomb", group_id: group_id, item_id: item_id, image: upload_image}
    end

    def api_url
      Rails.configuration.settings.honeypot_url
    end
end
