class ShowcaseList
  attr_reader :sections

  def initialize(sections, showcase)
    @sections = sections
    @showcase = showcase
  end

  delegate :exhibit, to: :showcase

  attr_reader :showcase
end
