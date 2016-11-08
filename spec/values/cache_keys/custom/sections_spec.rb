require "rails_helper"

RSpec.describe CacheKeys::Custom::Sections do
  context "edit" do
    let(:item) { instance_double(Item, id: 1, media: "media")}
    let(:section) { instance_double(Section, collection: "collection", item: item) }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.edit(section: section)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [section, section.collection, section.item.media])
      subject.edit(section: section)
    end
  end
end
