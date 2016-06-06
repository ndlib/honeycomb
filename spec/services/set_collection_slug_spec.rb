require "rails_helper"

describe SetCollectionSlug do
  let(:collection) { instance_double(Collection, "url_slug=" => "test", valid?: true, save: true) }
  let(:collection2) { Collection.new(name_line_1: "TEST", unique_id: "1234567890") }
  let(:collection3) { Collection.new(name_line_1: "TEST2", unique_id: "0987654321") }
  let(:collection4) { Collection.new(name_line_1: "TEST3") }
  let(:errors) { instance_double(ActiveModel::RecordNotUnique, full_messages: []) }
  subject(:subject) { SetCollectionSlug.new(collection, "test") }

  describe "#set_slug!" do
    it "should set slug" do
      expect(collection).to receive(:url_slug=).with("test")
      subject.set_slug!
    end

    it "should save the collection record" do
      expect(collection).to receive(:save).and_return(true)
      subject.set_slug!
    end

    it "should return false if the save fails" do
      allow(collection).to receive(:save).and_return(false)
      expect(subject.set_slug!).to be_falsey
    end

    it "should raise exception if slug is duplicate" do
      described_class.call(collection2, "test")
      expect { described_class.call(collection3, "test") }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "should raise exception if collection not valid" do
      expect { described_class.call(collection4, "test") }.to raise_error(RuntimeError, "Cannot set slug: collection record not valid")
    end
  end

  describe ".call" do
    it "uses the set_slug! method" do
      expect_any_instance_of(SetCollectionSlug).to receive(:set_slug!)
      SetCollectionSlug.call(collection, "test")
    end
  end
end
