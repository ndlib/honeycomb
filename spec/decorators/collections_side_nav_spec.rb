require "rails_helper"

RSpec.describe CollectionsSideNav do
  let(:collection) { double(Collection, id: 1) }

  describe "#homepage_link" do
    let(:context) { double("context", site_setup_form_collection_path: "path", link_to: "link") }
    let(:subject) { described_class.new(collection: collection, form: nil) }

    before(:each) do
      allow(subject).to receive(:h).and_return(context)
    end

    it "returns a link to the homepage_form" do
      expect(subject.homepage_link).to eq("link")
    end

    it "calls the correct path method" do
      expect(context).to receive(:site_setup_form_collection_path).with(collection, form: "homepage")
      subject.homepage_link
    end
  end

  describe "#collection_introduction_link" do
    let(:context) { double("context", site_setup_form_collection_path: "path", link_to: "link") }
    let(:subject) { described_class.new(collection: collection, form: nil) }

    before(:each) do
      allow(subject).to receive(:h).and_return(context)
    end

    it "returns a link to the collection_introduction_form" do
      expect(subject.collection_introduction_link).to eq("link")
    end

    it "calls the correct path method" do
      expect(context).to receive(:site_setup_form_collection_path).with(collection, form: "collection_introduction")
      subject.collection_introduction_link
    end
  end

  describe "#about_text_link" do
    let(:context) { double("context", site_setup_form_collection_path: "path", link_to: "link") }
    let(:subject) { described_class.new(collection: collection, form: nil) }

    before(:each) do
      allow(subject).to receive(:h).and_return(context)
    end

    it "returns a link to the about_text_form" do
      expect(subject.about_text_link).to eq("link")
    end

    it "calls the correct path method" do
      expect(context).to receive(:site_setup_form_collection_path).with(collection, form: "about_text")
      subject.about_text_link
    end
  end

  describe "#copyright_text_link" do
    let(:context) { double("context", site_setup_form_collection_path: "path", link_to: "link") }
    let(:subject) { described_class.new(collection: collection, form: nil) }

    before(:each) do
      allow(subject).to receive(:h).and_return(context)
    end

    it "returns a link to the copyright_text_link" do
      expect(subject.copyright_text_link).to eq("link")
    end

    it "calls the correct path method" do
      expect(context).to receive(:site_setup_form_collection_path).with(collection, form: "copyright_text")
      subject.copyright_text_link
    end
  end

  describe "#active_tab_class" do
    let(:context) { double("context") }
    let(:subject) { described_class.new(collection: collection, form: "form") }

    before(:each) do
      allow(subject).to receive(:h).and_return(context)
    end

    it "returns active when the tab == the form " do
      expect(subject.active_tab_class(tab: "form")).to eq("active")
    end

    it "returns empty string when the tab != form " do
      expect(subject.active_tab_class(tab: "not_the_form")).to eq("")
    end

    it "returns active if the form is nil and the tab == homepage " do
      subject = described_class.new(collection: collection, form: nil)
      expect(subject.active_tab_class(tab: "homepage")).to eq("active")
    end
  end
end
