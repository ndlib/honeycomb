require "rails_helper"

RSpec.describe V1::PageJSONDecorator do
  subject { described_class.new(page) }
  let(:collection) { instance_double(Collection, unique_id: "collection1") }
  let(:page) do
    instance_double(Page,
                    collection: collection,
                    unique_id: "page1",
                    slug: "page1",
                    name: "page1",
                    image: nil,
                    content: "<html/>",
                    updated_at: nil)
  end

  describe "generic fields" do
    [:id, :unique_id, :collection, :updated_at, :name, :content, :items].each do |field|
      it "responds to #{field}" do
        expect(subject).to respond_to(field)
      end
    end
  end

  describe "#at_id" do
    let(:page) { double(Page, unique_id: "page_id") }

    it "returns the path to the id" do
      expect(subject.at_id).to eq("http://test.host/v1/pages/page_id")
    end
  end

  describe "#collection_url" do
    let(:collection) { double(Collection, unique_id: "collection_id") }
    let(:page) { double(Page, collection: collection) }

    it "returns the path to the items" do
      expect(subject.collection_url).to eq("http://test.host/v1/collections/collection_id")
    end
  end

  describe "#slug" do
    let(:page) { double(Page, slug: "sluggish") }

    it "calls the slug generator" do
      expect(CreateURLSlug).to receive(:call).with(page.slug)
      subject.slug
    end
  end

  describe "#display" do
    let(:json) { Jbuilder.new }

    it "doesn't error" do
      subject.display(json)
    end

    expected_keys = [
      "@context",
      "@type",
      "@id",
      "isPartOf/collection",
      "additionalType",
      "id",
      "slug",
      "name",
      "image",
      "content",
      "last_updated"
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

    it "returns nil if the showcase is nil " do
      expect(described_class.new(nil).display(json)).to be_nil
    end
  end

  describe "#next" do
    it "uses the site objects query to retrieve the next object" do
      expect_any_instance_of(SiteObjectsQuery).to receive(:next).with(collection_object: page)
      subject.next
    end
  end

  describe "#previous" do
    it "uses the site objects query to retrieve the previous object" do
      expect_any_instance_of(SiteObjectsQuery).to receive(:previous).with(collection_object: page)
      subject.previous
    end
  end

  describe "#image" do
    it "calls v1 image json decorator" do
      allow(page).to receive(:image).and_return("image")
      expect(V1::ImageJSONDecorator).to receive(:new).and_return({})
      subject.image
    end

    it "returns nil if there is no image" do
      allow(page).to receive(:image).and_return(nil)
      expect(subject.image).to eq(nil)
    end
  end

  it "gives the correct additional_type" do
    expect(subject.additional_type).to eq("https://github.com/ndlib/honeycomb/wiki/Page")
  end
end
