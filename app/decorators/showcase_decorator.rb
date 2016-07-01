class ShowcaseDecorator < Draper::Decorator
  delegate :id, :name_line_1, :name_line_2, :description, to: :object

  def sections
    SectionQuery.new(object.sections).ordered
  end

  def honeypot_image_url
    if object.image
      object.image.json_response["thumbnail/small"]["contentUrl"]
    else
      {}
    end
  end
end
