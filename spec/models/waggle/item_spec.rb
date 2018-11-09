require "rails_helper"

RSpec.describe Waggle::Item do
  let(:item_id) { "pig-in-mud" }
  let(:raw_data) { File.read(Rails.root.join("spec/fixtures/v1/items/#{item_id}.json")) }
  let(:data) { JSON.parse(raw_data).fetch("items") }
  let(:subject) { described_class.from_hash(data) }

  describe "id" do
    it "is the id" do
      expect(subject.id).to eq(data.fetch("id"))
    end
  end

  describe "unique_id" do
    it "is the id" do
      expect(subject.unique_id).to eq(data.fetch("id"))
    end
  end

  describe "at_id" do
    it "is the @id" do
      expect(subject.at_id).to eq(data.fetch("@id"))
    end
  end

  describe "collection_id" do
    it "is the @id" do
      expect(subject.collection_id).to eq(data.fetch("collection_id"))
    end
  end

  describe "type" do
    it "is Item" do
      expect(subject.type).to eq("ImageObject")
    end
  end

  describe "children" do
    let(:decorator_with_child) { instance_double(V1::ItemJSONDecorator, parent: nil, children: ["child1"]) }
    let(:decorator_many_child) { instance_double(V1::ItemJSONDecorator, parent: nil, children: ["child1", "child2", "child3"]) }
    let(:decorator_barren) { instance_double(V1::ItemJSONDecorator, parent: data.fetch("id"), children: []) }

    it "returns empy array with no chlidren" do
      test_item = described_class.new(decorator_barren, data)
      expect(test_item.children).to eq([])
    end

    it "returns children when present" do
      test_item = described_class.new(decorator_with_child, data)
      expect(test_item.children).to eq(["child1"])
    end

    it "returns children when present" do
      test_item = described_class.new(decorator_many_child, data)
      expect(test_item.children).to eq(["child1", "child2", "child3"])
    end
  end

  describe "parent" do
    let(:parent) { instance_double(Item, unique_id: "parent_id") }
    let(:decorator_parent) { instance_double(V1::ItemJSONDecorator, parent: nil, children: []) }
    let(:decorator_child) { instance_double(V1::ItemJSONDecorator, parent: parent, children: []) }

    it "is a parent when it has no parent" do
      test_item = described_class.new(decorator_parent, data)
      expect(test_item.part_parent).to eq("_is_parent_")
    end

    it "returns nil parent when no parent" do
      test_item = described_class.new(decorator_parent, data)
      expect(test_item.part_parent).to eq("_is_parent_")
    end

    it "returns parent when present" do
      test_item = described_class.new(decorator_child, data)
      expect(test_item.part_parent).to eq("https://localhost:3017/v1/item/parent_id")
    end

    it "is not a parent if it has one" do
      test_item = described_class.new(decorator_child, data)
      expect(test_item.parent).to eq(parent)
    end
  end

  describe "thumbnail_url" do
    it "is the media's medium thumbnail contentUrl when the media is an ImageObject" do
      data["media"]["@type"] = "ImageObject"
      expect(subject.thumbnail_url).to eq(data["media"]["thumbnail/medium"]["contentUrl"])
    end

    it "is the media's thumbnailUrl when the media is an AudioObject" do
      data["media"]["@type"] = "AudioObject"
      data["media"]["thumbnailUrl"] = "audio thumbnail"
      expect(subject.thumbnail_url).to eq("audio thumbnail")
    end

    it "is the media's thumbnailUrl when the media is an VideoObject" do
      data["media"]["@type"] = "VideoObject"
      data["media"]["thumbnailUrl"] = "video thumbnail"
      expect(subject.thumbnail_url).to eq("video thumbnail")
    end

    it "returns empty string if the medium thumbnail is nil" do
      data["media"]["thumbnail/medium"] = nil
      expect(subject.thumbnail_url).to eq("")
    end
  end

  describe "last_updated" do
    it "is a formatted Time" do
      expect(subject.last_updated).to eq(Time.zone.parse(data.fetch("last_updated")).utc.strftime("%Y-%m-%dT%H:%M:%SZ"))
    end
  end

  describe "self.load" do
    it "load the database record using ItemQuery" do
      expect_any_instance_of(ItemQuery).to receive(:public_find).with(item_id)
      described_class.load(item_id)
    end
  end

  describe "self.from_item" do
    let(:decorator) { instance_double(V1::ItemJSONDecorator, to_hash: { test: "test" }) }
    let(:item) { instance_double(Item) }
    subject { described_class.from_item(item) }

    it "converts an item to its api hash and instantiates a new waggle item" do
      expect(V1::ItemJSONDecorator).to receive(:new).with(item).and_return(decorator)
      expect(described_class).to receive(:new).with(decorator, decorator.to_hash).and_return("waggle item")
      expect(subject).to eq("waggle item")
    end
  end

  describe "metadata" do
    it "is a Metadata object" do
      allow(subject).to receive(:metadata_configuration).and_return(double)
      expect(Waggle::Metadata::Set).to receive(:new).and_return("METADATASET")
      expect(subject.metadata).to eq("METADATASET")
    end
  end
end
