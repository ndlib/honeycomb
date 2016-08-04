module Destroy
  class Item
    attr_reader :destroy_section

    # Allow injecting destroy objects to use when cascading
    def initialize(destroy_section: nil)
      @destroy_section = destroy_section || Destroy::Section.new
    end

    # Destroy the object only
    def destroy!(item:)
      unless item.pages.any? || item.sections.any?
        item.destroy!
        remove_from_index(item: item)
      end
    end

    # Destroys this object and all associated objects.
    def cascade!(item:)
      ActiveRecord::Base.transaction do
        item.sections.each do |child|
          @destroy_section.cascade!(section: child)
        end
        item.pages.each do |page|
          RemovePageItem.call(page, item)
          item.pages.delete(page)
        end
        item.children.each do |child|
          cascade!(item: child)
        end
        destroy!(item: item)
      end
    end

    private

    def remove_from_index(item:)
      Index::Item.remove!(item)
    end
  end
end
