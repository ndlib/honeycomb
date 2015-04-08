class ReorderSections
  attr_reader :current_items_in_order, :update_item

  def self.call(current_items_in_order, update_item)
    new(current_items_in_order, update_item).reorder!
  end

  def initialize(current_items_in_order, update_item)
    @current_items_in_order = current_items_in_order
    @update_item = update_item
  end

  def original_list
    @original_list ||= current_items_in_order.to_a.compact.reject{|s| s == update_item}
  end

  def reorder!
    insert_index = original_list.find_index{|section| section.order >= update_item.order}
    insert_index ||= original_list.count
    res = original_list.insert(insert_index, update_item).compact

    res.each_with_index do |s, index|
      check_and_update_order!(s, index)
    end

    true
  end

  private

    def check_and_update_order!(item, new_order)
      if item.order != new_order
        item.order = new_order
        item.save!
      end
    end

end
