class SaveSection
  attr_reader :section, :params

  def self.call(section, params)
    new(section, params).save
  end

  def initialize(section, params)
    @section = section
    @params = params
  end

  def save
    section.attributes = params

    current_order
    if section.save && fix_order!
      check_unique_id
      section
    else
      false
    end
  end

  private

    def current_order
      @current_order ||= SectionQuery.new(section.showcase.sections).all_in_showcase
    end

    def fix_order!
      ReorderSections.call(current_order, section)
    end

    def check_unique_id
      CreateUniqueId.call(section)
    end
end
