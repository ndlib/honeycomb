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
    let(:showcase) { instance_double(Showcase, collection: "collection") }
    let(:showcase_json) do
      instance_double(V1::ShowcaseJSONDecorator,
                      collection: "collection",
                      sections: "sections",
                      items: "items",
                      next: "next",
                      object: showcase)
    end

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.show(showcase: showcase_json)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).
        to receive(:generate).
        with(record: [showcase, showcase_json.collection, showcase_json.sections, showcase_json.items, showcase_json.next])
      subject.show(showcase: showcase_json)
    end
  end
end
