class Thumbnail < Draper::Decorator
  attr_reader :honeypot_image
  attr_reader :extraStyles
  attr_reader :thumbType

  def self.display(honeypot_image, type, extraStyles={})
    new(honeypot_image, type, extraStyles).display
  end

  def initialize(honeypot_image, type, extraStyles={})
    @honeypot_image = honeypot_image
    @extraStyles = extraStyles
    @thumbType = type
  end

  def display
    h.react_component("Thumbnail", thumbnailUrl: image_json, extraStyle: extraStyles,
      thumbType: thumbType, mediaType: media_type)
  end

  def self.url(honeypot_image)
    new(honeypot_image, nil).url
  end

  def url
    image_json
  end

  private

  def image_json
    if honeypot_image
      data = honeypot_image.json_response
      if data["thumbnailUrl"]
        data["thumbnailUrl"]
      elsif data["contentUrl"]
        data["contentUrl"]
      end
    else
      ""
    end
  end

  def media_type
    if honeypot_image
      honeypot_image.json_response["@type"]
    else
      nil
    end
  end
end
