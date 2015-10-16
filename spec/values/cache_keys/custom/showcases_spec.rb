require "rails_helper"

RSpec.describe CacheKeys::Custom::Showcases do
  context "index" do
    let(:collection) { instance_double(Collection, showcases: "showcases") }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.index(collection: collection)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [collection.showcases, collection])
      subject.index(collection: collection)
    end
  end

  context "edit" do
    let(:showcase) { instance_double(Showcase, collection: "collection") }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.edit(showcase: showcase)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [showcase, showcase.collection])
      subject.edit(showcase: showcase)
    end
  end

  context "title" do
    let(:showcase) { instance_double(Showcase, collection: "collection") }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.title(showcase: showcase)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [showcase, showcase.collection])
      subject.title(showcase: showcase)
    end
  end
end
