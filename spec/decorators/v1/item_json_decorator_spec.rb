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

  describe "#at_id" do
    let(:item) { double(Item, unique_id: "adsf") }

    it "returns the path to the id" do
      expect(subject.at_id).to eq("http://test.host/v1/items/adsf")
    end
  end

  describe "#collection_url" do
    let(:item) { double(Item, collection: collection) }
    let(:collection) { double(Collection, unique_id: "colasdf") }

    it "returns the path to the items" do
      expect(subject.collection_url).to eq("http://test.host/v1/collections/colasdf")
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
    let(:item) { double(Item, honeypot_image: honeypot_image) }
    let(:honeypot_image) { double(HoneypotImage, json_response: "json_response") }

    it "gets the honeypot_image json_response" do
      expect(honeypot_image).to receive(:json_response).and_return("json_response")
      expect(subject.image).to eq("json_response")
    end
  end

  describe "#display" do
    let(:item) { double(Item) }

    it "calls the partial for the display" do
      expect(json).to receive(:partial!).with("/v1/items/item", item_object: item)
      subject.display(json)
    end

    it "returns nil if the item is nil " do
      expect(described_class.new(nil).display(json)).to be_nil
    end
  end

  describe "#metadata" do

    it "users the metadataJSON object to get metadata" do
      expect(V1::MetadataJSON).to receive(:metadata).with(item).and_return("metadata")
      expect(subject.metadata).to eq("metadata")
    end
  end
end
