require "rails_helper"

RSpec.describe V1::ItemJSONDecorator do
  subject { described_class.new(item) }

  let(:item) { double(Item) }
  let(:json) { double }

  describe "generic fields" do
    [:id, :name, :collection, :unique_id, :description, :updated_at].each do |field|
      it "responds to #{field}" do
        expect(subject).to respond_to(field)
      end
    end
  end

  describe "self.display" do
    subject { described_class.display(item, json) }

    it "calls display on a new instance" do
      expect(described_class).to receive(:new).with(item).and_call_original
      expect_any_instance_of(described_class).to receive(:display).with(json).and_return("display called")
      expect(subject).to eq("display called")
    end
  end

  describe "#at_id" do
    let(:item) { double(Item, unique_id: "adsf") }

    it "returns the path to the id" do
      expect(subject.at_id).to eq("http://test.host/v1/items/adsf")
    end
  end

  context "collection" do
    let(:item) { double(Item, collection: collection) }
    let(:collection) { double(Collection, unique_id: "colasdf") }

    describe "#collection_id" do
      it "is the collection id" do
        expect(subject.collection_id).to eq("colasdf")
      end
    end

    describe "#collection_url" do
      it "returns the path to the items" do
        expect(subject.collection_url).to eq("http://test.host/v1/collections/colasdf")
      end
    end
  end

  context "nil collection" do
    let(:item) { instance_double(Item, collection: nil) }

    describe "#collection_id" do
      it "is nil" do
        expect(subject.collection_id).to be_nil
      end
    end

    describe "#collection_url" do
      it "returns nil" do
        expect(subject.collection_url).to be_nil
      end
    end
  end

  describe "#slug" do
    let(:item) { double(Item, name: "sluggish") }

    it "Calls the slug generator" do
      expect(CreateURLSlug).to receive(:call).with(item.name)
      subject.slug
    end
  end

  describe "#image" do
    let(:item) { double(Item, honeypot_image: honeypot_image, image_ready?: true) }
    let(:honeypot_image) { double(HoneypotImage, json_response: "json_response") }

    it "gets the honeypot_image json_response" do
      expect(honeypot_image).to receive(:json_response).and_return("json_response")
      expect(subject.image).to eq("json_response")
    end
  end

  context "valid objects" do
    let(:collection) { Collection.new(unique_id: "test-collection") }
    let(:item) { Item.new(unique_id: "test-item", collection: collection) }
    let(:json) { Jbuilder.new }

    describe "#display" do
      it "doesn't error" do
        subject.display(json)
      end

      expected_keys = [
        "@context",
        "@type",
        "@id",
        "isPartOf/collection",
        "id",
        "slug",
        "name",
        "description",
        "image",
        "metadata",
        "last_updated",
        "collection_id"
      ]

      expected_keys.each do |key|
        it "sets #{key}" do
          subject.display(json)
          keys = JSON.parse(json.target!).keys
          expect(keys).to include(key)
        end
      end

      it "doesn't include extra keys" do
        subject.display(json)
        keys = JSON.parse(json.target!).keys
        expect(keys - expected_keys).to eq([])
      end

      it "returns nil if the item is nil " do
        expect(described_class.new(nil).display(json)).to be_nil
      end
    end

    describe "#to_json" do
      it "creates JSON output" do
        item.name = "Test Item"
        json = subject.to_json
        parsed = JSON.parse(json)
        expect(parsed.fetch("name")).to eq("Test Item")
      end
    end
  end

  describe "#metadata" do
    it "users the metadataJSON object to get metadata" do
      expect(V1::MetadataJSON).to receive(:metadata).with(item).and_return("metadata")
      expect(subject.metadata).to eq("metadata")
    end
  end
end
