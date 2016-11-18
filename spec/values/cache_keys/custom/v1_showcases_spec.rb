require "rails_helper"

RSpec.describe CacheKeys::Custom::V1Showcases do
  context "index" do
    let(:collection) { instance_double(Collection, showcases: "showcases") }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.index(collection: collection)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [collection, "showcases"])
      subject.index(collection: collection)
    end
  end

  context "show" do
    let(:collection) { instance_double(Collection, collection_configuration: "collection_configuration") }
    let(:showcase) { instance_double(Showcase, collection: "collection") }
    let(:showcase_json) do
      instance_double(V1::ShowcaseJSONDecorator,
                      collection: collection,
                      sections: "sections",
                      items: "items",
                      items_media: "items.media",
                      next: "next",
                      object: showcase)
    end

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.show(showcase: showcase_json)
    end

    it "uses the correct data" do
      record = [showcase,
                showcase_json.collection,
                collection.collection_configuration,
                showcase_json.sections,
                showcase_json.items,
                showcase_json.items_media,
                showcase_json.next]
      expect_any_instance_of(CacheKeys::ActiveRecord).
        to receive(:generate).
        with(record: record)
      subject.show(showcase: showcase_json)
    end
  end
end
