require 'rails_helper'

RSpec.describe V1::ShowcaseJSONDecorator do
  subject {described_class.new(showcase)}

  let(:collection) { double(Collection, id: 1, unique_id: "colasdf", title: 'title title') }
  let(:showcase) { double(Showcase, id: 1, sections: [], description: nil, unique_id: "adsf", title: 'title title', collection: collection, honeypot_image: honeypot_image )}
  let(:honeypot_image) { double(HoneypotImage, json_response: 'json_response') }
  let(:json) { double }

  describe "generic fields" do
    [:id, :title, :description, :unique_id, :image, :collection, :updated_at].each do | field |
      it "responds to #{field}" do
        expect(subject).to respond_to(field)
      end
    end
  end


  describe "#at_id" do

    it "returns the path to the id" do
      expect(subject.at_id).to eq("http://test.host/v1/showcases/adsf")
    end
  end


  describe "#collection_url" do

    it "returns the path to the items" do
      expect(subject.collection_url).to eq("http://test.host/v1/collections/colasdf")
    end
  end

  describe "#description" do
    it "converts null to empty string" do
      expect(subject.description).to eq("")
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

  describe "#sections" do

    it "uses the section query object all_in_showcase" do
      expect_any_instance_of(SectionQuery).to receive(:all_in_showcase).and_return(['results'])
      expect(subject.sections).to eq(['results'])
    end

    it "filters on just the sections in the showcase" do
      expect(subject).to receive(:sections).and_return([])
      subject.sections
    end
  end

  describe "#display" do

    it "calls the partial for the display" do
      expect(json).to receive(:partial!).with("/v1/showcases/showcase", {:showcase_object => showcase })
      subject.display(json)
    end
  end
end
