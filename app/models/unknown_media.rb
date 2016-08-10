class UnknownMedia < Media
  attr_accessor :media_type

  def initialize(media_type:)
    @media_type = media_type
  end

  def valid?
    false
  end

  def errors
    {
      error: [
        {
            name: "media_type",
            description: "Unknown media type '#{media_type}'"
        }
      ]
    }
  end

  def json_response
    nil
  end
end
