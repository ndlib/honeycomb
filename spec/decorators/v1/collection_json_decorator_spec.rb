require "rails_helper"

RSpec.describe V1::CollectionJSONDecorator do
  subject { V1::CollectionJSONDecorator.new(collection) }

  let(:collection) { double(Collection) }

  describe "generic fields" do
    [:id,
     :unique_id,
     :about,
     :updated_at].each do |field|
      it "responds to #{field}" do
        expect(subject).to respond_to(field)
      end
    end
  end

  describe "#description" do
    let(:collection) { double(Collection, description: nil) }

    it "converts null to empty string" do
      expect(subject.description).to eq("")
    end

    it "delegates to collection" do
      expect(collection).to receive(:description).and_return("desc")
      expect(subject.description).to eq("desc")
    end
  end

  describe "#about" do
    let(:collection) { double(Collection, about: nil) }

    it "converts null to empty string" do
      expect(subject.about).to eq("")
    end

    it "gets the value from the collection" do
      allow(collection).to receive(:about).and_return("about")
      expect(subject.about).to eq("about")
    end
  end

  describe "#display_page_title" do
    let(:collection) { instance_double(Collection) }

    it "returns true value from the collection when the flag is false" do
      allow(collection).to receive(:hide_title_on_home_page?).and_return(false)
      expect(subject.display_page_title).to eq(true)
    end

    it "returns false when the collection when the flag is false" do
      allow(collection).to receive(:hide_title_on_home_page?).and_return(true)
      expect(subject.display_page_title).to eq(false)
    end
  end

  describe "#copyright" do
    let(:collection) { double(Collection) }
    let(:default) do
      "<p><a href=\"http://www.nd.edu/copyright/\">Copyright</a> " +
        Date.today.year.to_s +
        " <a href=\"http://www.nd.edu\">University of Notre Dame</a></p>"
    end

    it "converts null to default string" do
      allow(collection).to receive(:copyright).and_return(nil)
      expect(subject.copyright).to eq(default)
    end

    it "converts empty string to default string" do
      allow(collection).to receive(:copyright).and_return("")
      expect(subject.copyright).to eq(default)
    end

    it "gets the value from the collection" do
      allow(collection).to receive(:copyright).and_return("copyright")
      expect(subject.copyright).to eq("copyright")
    end
  end

  describe "#short_intro" do
    let(:collection) { double(Collection, short_intro: nil) }

    it "converts null to empty string" do
      expect(subject.short_intro).to eq("")
    end

    it "gets the value from #short_intro" do
      expect(subject).to receive(:short_intro).and_return("intro")
      expect(subject.short_intro).to eq("intro")
    end
  end

  describe "#at_id" do
    let(:collection) { double(Collection, unique_id: "adsf") }

    it "returns the path to the id" do
      expect(subject.at_id).to eq("http://localhost:3017/v1/collections/adsf")
    end
  end

  describe "#items_url" do
    let(:collection) { double(Collection, unique_id: "adsf") }

    it "returns the path to the items" do
      expect(subject.items_url).to eq("http://localhost:3017/v1/collections/adsf/items")
    end
  end

  describe "#metadata_configuration_url" do
    let(:collection) { double(Collection, unique_id: "adsf") }

    it "returns the path to the items" do
      expect(subject.metadata_configuration_url).to eq("http://localhost:3017/v1/collections/adsf/configurations")
    end
  end

  describe "#external_url" do
    context "when collection url is populated" do
      let(:collection) { double(Collection, url: "http://nosite.com") }

      it "returns a url" do
        expect(subject.external_url).to eq "http://nosite.com"
      end
    end

    context "when collection url is nil" do
      let(:collection) { double(Collection, url: nil) }

      it "returns an empty string" do
        expect(subject.external_url).to eq ""
      end
    end
  end

  describe "#additional_type" do
    context "when collection url is populated" do
      let(:collection) { double(Collection, url: "http://nosite.com") }

      it "returns link to ExternalCollection definition" do
        expect(subject.additional_type).to eq "https://github.com/ndlib/honeycomb/wiki/ExternalCollection"
      end
    end

    context "when collection url is nil" do
      let(:collection) { double(Collection, url: nil) }

      it "returns link to DecCollection definition" do
        expect(subject.additional_type).to eq "https://github.com/ndlib/honeycomb/wiki/DecCollection"
      end
    end
  end

  describe "#slug" do
    let(:collection) { double(Collection, name_line_1: "sluggish") }

    it "calls the slug generator" do
      expect(CreateURLSlug).to receive(:call).with(collection.name_line_1)
      subject.slug
    end
  end

  describe "#items" do
    let(:collection) { double(Collection, items: []) }

    it "queries for all the published items" do
      expect_any_instance_of(ItemQuery).to receive(:only_top_level).and_return(["items"])

      expect(subject.items).to eq(["items"])
    end
  end

  describe "#showcases" do
    let(:collection) { double(Collection, showcases: []) }

    it "queries for all the published showcases" do
      expect_any_instance_of(ShowcaseQuery).to receive(:public_api_list).and_return(["showcases"])

      expect(subject.showcases).to eq(["showcases"])
    end
  end

  describe "#pages" do
    let(:collection) { double(Collection, pages: []) }

    it "queries for ordered list of pages" do
      expect_any_instance_of(PageQuery).to receive(:ordered)
      subject.pages
    end
  end

  describe "#image" do
    let(:collection) { instance_double(Collection, image: image) }
    let(:image) { instance_double(Image, type: "Image") }

    before(:each) do
      allow(SerializeMedia).to receive(:to_hash).and_return(image: "image")
    end

    it "gets the image json_response" do
      allow(SerializeMedia).to receive(:to_hash).and_return(image: "image")
      expect(subject.image).to eq(image: "image")
    end
  end

  describe "#display" do
    let(:json) { double }

    it "calls the partial for the display" do
      expect(json).to receive(:partial!).with("/v1/collections/collection", collection_object: collection)

      subject.display(json)
    end
  end
end
