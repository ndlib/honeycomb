require "rails_helper"

RSpec.describe V1::SectionJSONDecorator do
  subject { described_class.new(section) }
  let(:section) { double(Section) }

  describe "generic fields" do
    [:id, :caption, :unique_id, :item, :updated_at, :order].each do |field|
      it "responds to #{field}" do
        expect(subject).to respond_to(field)
      end
    end
  end

  describe "#name" do
    let(:section) { double(Section, name: "section_name", item: item) }
    let(:item) { double(Item, name: "item_name") }

    it "calls SectionTitle to determine the name" do
      expect(SectionName).to receive(:call)
      subject.name
    end
  end

  describe "#at_id" do
    let(:section) { double(Section, unique_id: "adsf") }

    it "returns the path to the id" do
      expect(subject.at_id).to eq("http://test.host/v1/sections/adsf")
    end
  end

  describe "#collection_url" do
    let(:section) { double(Section, collection: collection) }
    let(:collection) { double(Collection, unique_id: "coladsf") }

    it "returns the path to the items" do
      expect(subject.collection_url).to eq("http://test.host/v1/collections/coladsf")
    end
  end

  describe "#showcase_url" do
    let(:section) { double(Section, showcase: showcase) }
    let(:showcase) { double(Showcase, unique_id: "showadsf") }

    it "returns the path to the items" do
      expect(subject.showcase_url).to eq("http://test.host/v1/showcases/showadsf")
    end
  end

  describe "#description" do
    let(:section) { double(Section, description: nil) }

    it "converts null to empty string" do
      expect(subject.description).to eq("")
    end

    it "delegates to section" do
      expect(section).to receive(:description).and_return("desc")
      expect(subject.description).to eq("desc")
    end
  end

  describe "#slug" do
    let(:section) { double(Section, slug: "slug") }

    it "Calls the slug generator" do
      expect(CreateURLSlug).to receive(:call).with(section.slug)
      subject.slug
    end
  end

  describe "#next" do
    it "calls the query object" do
      expect_any_instance_of(SectionQuery).to receive(:next).with(section)
      subject.next
    end
  end

  describe "#previous" do
    it "calls the query object" do
      expect_any_instance_of(SectionQuery).to receive(:previous).with(section)
      subject.previous
    end
  end

  describe "#display" do
    let(:json) { double }

    it "calls the partial for the display" do
      expect(json).to receive(:partial!).with("/v1/sections/section", section_object: section)
      subject.display(json)
    end
  end
end
