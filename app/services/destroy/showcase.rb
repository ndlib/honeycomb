module Destroy
  class Showcase
    attr_reader :destroy_section

    # Allow injecting destroy objects to use when cascading
    def initialize(destroy_section: nil)
      @destroy_section = destroy_section || Destroy::Section.new
    end

    # Destroy the object only
    def destroy!(showcase:)
      if CanDelete.showcase?(showcase)
        showcase.destroy!
      end
    end

    # Destroys this object and all associated objects.
    def force_cascade!(showcase:)
      ActiveRecord::Base.transaction do
        showcase.sections.each do |child|
          @destroy_section.cascade!(section: child)
        end
        showcase.destroy!
      end
    end

    def cascade!(showcase:)
      if CanDelete.showcase?(showcase)
        force_cascade!(showcase: showcase)
      end
    end
  end
end
