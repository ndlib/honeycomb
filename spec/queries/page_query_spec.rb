require "rails"
require "rails_helper"

describe PageQuery do
  subject { described_class.new(relation) }
  let(:relation) { Page.all }

  describe "#relation" do
    it "returns the relation" do
      expect(subject.relation).to eq(relation)
    end
  end

  describe "all" do
    it "returns all the pages" do
      expect(subject.all).to eq(relation)
    end
  end

  describe "ordered" do
    it "orders the result" do
      expect(relation).to receive(:order).with(:name).and_return(relation)
      subject.ordered
    end
  end

  describe "find" do
    it "finds the object" do
      expect(relation).to receive(:find).with(1)
      subject.find(1)
    end
  end

  describe "build" do
    it "builds a object off of the relation" do
      expect(relation).to receive(:build)
      subject.build
    end

    it "accepts default arguments" do
      item = subject.build(collection_id: 1)
      expect(item.collection_id).to eq(1)
    end
  end

  describe "public_find" do
    it "calls public_find!" do
      expect(relation).to receive(:find_by!).with(unique_id: "asdf")
      subject.public_find("asdf")
    end

    it "raises an error on not found" do
      expect { subject.public_find("asdf") }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  it "can be deleted if not included in a collection's site_path" do
    expect_any_instance_of(SiteObjectsQuery).to receive(:exists?).with(collection_object: relation).and_return(false)
    expect(subject.can_delete?).to eq(true)
  end

  it "cannot be deleted if included in a collection's site_path" do
    expect_any_instance_of(SiteObjectsQuery).to receive(:exists?).with(collection_object: relation).and_return(true)
    expect(subject.can_delete?).to eq(false)
  end
end
