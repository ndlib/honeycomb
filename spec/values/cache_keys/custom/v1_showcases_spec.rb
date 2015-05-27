require "rails_helper"

RSpec.describe CacheKeys::Custom::V1Showcases do
  context "index" do
    let(:collection) { instance_double(Collection, showcases: "showcases", exhibit: "exhibit") }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.index(collection: collection)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [collection, "exhibit", "showcases"])
      subject.index(collection: collection)
    end
  end

  context "show" do
    let(:showcase) { instance_double(Showcase, collection: "collection", sections: "sections", items: "items") }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.show(showcase: showcase)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [showcase, "collection", "sections", "items"])
      subject.show(showcase: showcase)
    end
  end
end
