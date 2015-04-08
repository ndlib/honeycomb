class SectionTitle
  attr_reader :section

  def self.call(section)
    new(section).title
  end

  def initialize(section)
    @section = section
  end

  def title
    if section.title.present?
      section.title
    elsif section.item && section.item.title.present?
      section.item.title
    else
      ''
    end
  end
end
