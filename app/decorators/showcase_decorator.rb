class ShowcaseDecorator < Draper::Decorator
  delegate :id, :name_line_1, :description, to: :object

  def sections
    SectionQuery.new(object.sections).ordered
  end

  def honeypot_image_url
    if object.honeypot_image
      object.honeypot_image.json_response["contentUrl"]
    else
      {}
    end
  end
end
