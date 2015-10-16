require "rails_helper"

RSpec.describe CacheKeys::Custom::V1Collections do
  context "index" do
    let(:collections) { instance_double(Collection) }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.index(collections: collections)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [collections])
      subject.index(collections: collections)
    end
  end

  context "show" do
    let(:collection) { instance_double(Collection) }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.show(collection: collection)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: collection)
      subject.show(collection: collection)
    end
  end
end
