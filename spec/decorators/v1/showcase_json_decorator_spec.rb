require "rails_helper"

RSpec.describe V1::ShowcaseJSONDecorator do
  subject { described_class.new(showcase) }

  let(:showcase) { double(Showcase) }

  describe "generic fields" do
    [:id, :description, :unique_id, :image, :collection, :updated_at].each do |field|
      it "responds to #{field}" do
        expect(subject).to respond_to(field)
      end
    end
  end

  describe "#at_id" do
    let(:showcase) { double(Showcase, unique_id: "showcae_id") }

    it "returns the path to the id" do
      expect(subject.at_id).to eq("http://test.host/v1/showcases/showcae_id")
    end
  end

  describe "#collection_url" do
    let(:collection) { double(Collection, unique_id: "collection_id") }
    let(:showcase) { double(Showcase, collection: collection) }

    it "returns the path to the items" do
      expect(subject.collection_url).to eq("http://test.host/v1/collections/collection_id")
    end
  end

  describe "#description" do
    let(:showcase) { double(Showcase, description: "description") }

    it "passes description to showcase#description" do
      expect(showcase).to receive(:description).and_return("description")
      expect(subject.description).to eq("description")
    end

    it "converts null to empty string" do
      expect(subject.description).to receive(:to_s)
      subject.description
    end
  end

  describe "#slug" do
    let(:showcase) { double(Showcase, slug: "sluggish") }

    it "calls the slug generator" do
      expect(CreateURLSlug).to receive(:call).with(showcase.slug)
      subject.slug
    end
  end

  describe "#image" do
    let(:showcase) { double(Showcase, honeypot_image: honeypot_image) }
    let(:honeypot_image) { double(HoneypotImage, json_response: "json_response") }

    it "gets the honeypot_image json_response" do
      expect(honeypot_image).to receive(:json_response).and_return("json_response")
      expect(subject.image).to eq("json_response")
    end

    it "gets the honeypot_image from the exhibit" do
      expect(showcase).to receive(:honeypot_image).and_return(honeypot_image)
      subject.image
    end
  end

  describe "#sections" do
    let(:showcase) { double(Showcase, sections: []) }

    it "uses the section query object ordered" do
      expect_any_instance_of(SectionQuery).to receive(:ordered).and_return(["results"])
      expect(subject.sections).to eq(["results"])
    end

    it "filters on just the sections in the showcase" do
      expect(subject).to receive(:sections).and_return([])
      subject.sections
    end
  end

  describe "#display" do
    let(:json) { double }

    it "calls the partial for the display" do
      expect(json).to receive(:partial!).with("/v1/showcases/showcase", showcase_object: showcase)
      subject.display(json)
    end
  end

  describe "#next" do
    it "uses the showcase query to retrieve the next showcase" do
      expect_any_instance_of(ShowcaseQuery).to receive(:next).with(showcase)
      subject.next
    end
  end

  describe "#previous" do
    it "uses the showcase query to retrieve the previous showcase" do
      expect_any_instance_of(ShowcaseQuery).to receive(:previous).with(showcase)
      subject.previous
    end
  end
end
