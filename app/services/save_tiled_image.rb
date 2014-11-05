class SaveTiledImage
  attr_reader :item

  def self.call(item)
    new(item).save!
  end

  def initialize(item)
    @item = item
  end

  def save!
    response = send_request

    if response && update_tiled_server(response)
      tiled_image
    else
      false
    end
  end

  private

    def tiled_image
      item.tiled_image || item.tiled_image.build
    end

    def update_tiled_server(request)
      tiled_image.width = request.body[:image][:width]
      tiled_image.height = request.body[:image][:height]
      tiled_image.uri = request.body[:image][:uri]

      tiled_image.save
    end

    def send_request
      response = connection.post('/image', post)
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

    def post
      { namespace: "honeycomb/#{item.collection.id}/#{item.id}", image: Faraday::UploadIO.new(item.image.path, item.image.content_type)  }
    end

    def api_url
      case Rails.env
      when 'development', 'test'
        'http://localhost:4567'
      else
        raise "set a url for the tile server api for the current environment"
      end
    end
end
