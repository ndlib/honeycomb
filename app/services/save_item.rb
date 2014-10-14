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
    item.attributes = params

    verify_title

    puts item.valid?
    puts item.errors.inspect
    item.save
  end


  private

    def verify_title
      if item.new_record? && item.title.blank?
        item.title = item.image_file_name
      end
    end
end
