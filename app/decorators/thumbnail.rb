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
    h.react_component("Thumbnail", thumbnailUrl: image_json, extraStyle: extraStyles, thumbType: thumbType)
  end

  private

  def image_json
    if honeypot_image
      honeypot_image.json_response["contentUrl"]
    else
      ""
    end
  end
end
