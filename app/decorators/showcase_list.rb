class ShowcaseList
  attr_reader :sections

  def initialize(sections, showcase)
    @sections = sections
    @showcase = showcase
  end

  def exhibit
    showcase.exhibit
  end

  attr_reader :showcase
end
