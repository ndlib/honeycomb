class ListEntryGenerator
  def self.showcase_entries(showcases)
    new(showcases).build(:showcase_entry)
  end

  def self.collection_entries(collections)
    new(collections).build(:collection_entry)
  end

  def self.page_entries(pages)
    new(pages).build(:page_entry)
  end

  def initialize(to_convert)
    @to_convert = to_convert
    @list_entries = []
  end

  def build(entry_fcn)
    if @to_convert
      @to_convert.each do |entry|
        @list_entries.push(send(entry_fcn, entry))
      end
    end
    @list_entries
  end

  private

  def showcase_entry(entry)
    {
      id: entry.unique_id,
      name: entry.name_line_1,
      updated: entry.updated_at,
      thumb: get_thumb(entry),
    }
  end

  def collection_entry(entry)
    {
      id: entry.id,
      name: entry.name_line_1,
      updated: entry.updated_at,
      thumb: CollectionImage.url(entry),
      count: entry.items.size,
      published: entry.published,
    }
  end

  def page_entry(entry)
    {
      id: entry.unique_id,
      name: entry.name,
      updated: entry.updated_at,
      thumb: get_thumb(entry),
    }
  end

  def get_thumb(entry)
    entry.image.json_response["contentUrl"] if (entry.image && entry.image.json_response)
  end

end
