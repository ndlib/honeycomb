# Handles CRUD operations on the media server Buzz for the associated
# media object
class BuzzMedia
  attr_reader :media

  def initialize(media:)
    @media = media
  end

  def self.call_create(media:)
    new(media: media).create
  end

  def self.call_update(media:)
    new(media: media).update
  end

  def create
    response = media_server_connection.post("/v1/media_files", create_json)
    if response.success?
      response.body["object"]
    else
      raise_exception(faraday_response: response)
    end
  end

  def update
    response = media_server_connection.put("/v1/media_files/" + @media.json_response["@id"], update_json)
    if response.success?
      response.body["object"]
    else
      raise_exception(faraday_response: response)
    end
  end

  private

  def create_json
    {
      media_file: {
        file_path: AllocateS3Url.new(media.uuid, media.file_name).file_name,
        media_type: @media.type.downcase
      }
    }
  end

  def update_json
    {
      media_file: {
        thumbnail_url: @media.thumbnail_url
      }
    }
  end

  def raise_exception(faraday_response:)
    case faraday_response.status
    when 422
      raise Buzz::UnprocessableEntity, faraday_response.body
    else
      raise Buzz::InternalServerError
    end
  end

  def media_server_connection
    @media_server_connection ||= Faraday.new(media_server_url) do |f|
      f.request :url_encoded
      f.adapter :net_http
      f.response :json, content_type: "application/json"
    end
  end

  def media_server_url
    Rails.configuration.settings.media_server_url
  end
end
