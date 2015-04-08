require 'rails_helper'

RSpec.describe V1::ItemJSONDecorator do
  subject {described_class.new(item)}

  let(:collection) { double(Collection, id: 1, unique_id: "colasdf", title: 'title title') }
  let(:item) { double(Item, id: 1, manuscript_url: "url", transcription: "transcript", description: "description", unique_id: "adsf", title: 'title title', collection: collection, honeypot_image: honeypot_image )}
  let(:honeypot_image) { double(HoneypotImage, json_response: 'json_response') }
  let(:json) { double }

  describe "generic fields" do
    [:id, :title, :collection, :unique_id, :description, :updated_at].each do | field |
      it "responds to #{field}" do
        expect(subject).to respond_to(field)
      end
    end
  end

  describe "#at_id" do

    it "returns the path to the id" do
      expect(subject.at_id).to eq("http://test.host/v1/items/adsf")
    end
  end


  describe "#collection_url" do

    it "returns the path to the items" do
      expect(subject.collection_url).to eq("http://test.host/v1/collections/colasdf")
    end
  end

  describe "#description" do
    it "converts null to empty string" do
      allow(item).to receive(:description).and_return(nil)
      expect(subject.description).to eq("")
    end
  end

  describe "#transcription" do
    it "converts null to empty string" do
      allow(item).to receive(:transcription).and_return(nil)
      expect(subject.transcription).to eq("")
    end
  end

  describe "#slug" do

    it "Calls the slug generator" do
      expect(CreateURLSlug).to receive(:call).with(collection.title).and_return('slug')
      expect(subject.slug).to eq("slug")
    end
  end

  describe "#image" do

    it "gets the honeypot_image json_response" do
      expect(honeypot_image).to receive(:json_response).and_return('json_response')
      expect(subject.image).to eq("json_response")
    end
  end


  describe "#display" do

    it "calls the partial for the display" do
      expect(json).to receive(:partial!).with("/v1/items/item", {:item_object => item })
      subject.display(json)
    end

    it "returns nil if the item is nil " do
      expect(described_class.new(nil).display(json)).to be_nil
    end
  end

  describe "#metadata" do

    it "creates a metadata hash of all metadata" do
      expect(subject.metadata).to eq([{:label=>"Title", :value=>"title title"}, {:label=>"Description", :value=>"description"}, {:label=>"Manuscript", :value=>"url"}, {:label=>"Transcript", :value=>"transcript"}])
    end
  end
end
