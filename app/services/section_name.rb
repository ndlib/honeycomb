class SectionName
  attr_reader :section

  def self.call(section)
    new(section).name
  end

  def initialize(section)
    @section = section
  end

  def name
    if section.name.present?
      section.name
    elsif section.item && section.item.name.present?
      section.item.name
    else
      ""
    end
  end
end
