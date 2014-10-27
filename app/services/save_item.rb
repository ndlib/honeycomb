class SaveItem
  attr_reader :params, :item

  def self.call(item, params)
    new(item, params).save
  end

  def initialize(item, params)
    @params = params
    @item = item
  end

  def save
    fix_image_param!

    item.attributes = params

    verify_title
    set_sortable_title

    item.save
  end

  private

    def verify_title
      if item.new_record? && item.title.blank?
        item.title = item.image_file_name
      end
    end

    def fix_image_param!
      params.delete(:image) if params[:image].nil?
    end

    def set_sortable_title
      item.sortable_title = SortableTitleConverter.convert(item.title)
    end
end
