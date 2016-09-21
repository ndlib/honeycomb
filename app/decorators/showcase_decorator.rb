class ShowcaseDecorator < Draper::Decorator
  delegate :id, :name_line_1, :name_line_2, :description, to: :object

  def sections
    SectionQuery.new(object.sections).ordered
  end

  def image
    SerializeMedia.to_hash(media: object.image) if object.image
  end
end
