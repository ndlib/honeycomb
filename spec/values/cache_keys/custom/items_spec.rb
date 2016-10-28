require "rails_helper"

RSpec.describe CacheKeys::Custom::Items do
  context "index" do
    let(:collection) { instance_double(Collection, items: "items") }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.index(collection: collection)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [collection, collection.items])
      subject.index(collection: collection)
    end
  end

  context "edit" do
    let(:collection) { instance_double(Collection, items: "items") }
    let(:item) { instance_double(Item, collection: collection, showcases: ["showcase1", "showcase2"], pages: ["page1", "page2"], media: "media") }
    let(:decorated_item) { ItemDecorator.new(item) }

    before(:each) do
      allow(decorated_item).to receive(:recent_children).and_return("recent_children")
    end

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.edit(decorated_item: decorated_item)
    end

    it "uses the correct data" do
      record = [decorated_item.collection, decorated_item.recent_children, decorated_item.object, decorated_item.showcases, decorated_item.pages, decorated_item.media]
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: record)
      subject.edit(decorated_item: decorated_item)
    end
  end
end
