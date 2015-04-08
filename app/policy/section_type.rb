class SectionType
  attr_reader :section

  def initialize(section)
    @section = section
  end

  def type
    if section.item_id.present?
      'image'
    else
      'text'
    end
  end

end
