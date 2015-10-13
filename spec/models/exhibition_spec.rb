require "rails_helper"

RSpec.describe Exhibition do
  [
    :name_line_1,
    :name_line_2,
    :items,
    :description,
    :unique_id,
    :exhibit,
    :published,
    :preview_mode,
    :updated_at,
    :image,
    :honeypot_image,
    :uploaded_image,
    :showcases,
    :about,
    :copyright,
    :hide_title_on_home_page,
    :short_intro,
    :site_intro,
    :url
  ].each do |field|
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  [
    :collection,
    :exhibit
  ].each do |field|
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
    end
  end

  describe "#full_name" do
    it "requires the name_line_1 field " do
      expect(subject).to have(1).error_on(:name_line_1)
    end

    it "concatinates name_line_1 and name_line_2 if there is a name_line_2" do
      subject.name_line_1 = "name line 1"
      subject.name_line_2 = "name line 2"

      expect(subject.full_name).to eq("name line 1 name line 2")
    end

    it "does not concatintate name_line_2 if there is no name_line_2" do
      subject.name_line_1 = "name line 1"

      expect(subject.full_name).to eq("name line 1")
    end
  end

  describe "#has honeypot image interface" do
    it "responds to image" do
      expect(subject).to respond_to(:image)
    end

    it "responds to honeypot_image" do
      expect(subject).to respond_to(:honeypot_image)
    end

    it "responds to collection" do
      expect(subject).to respond_to(:collection)
    end
  end

  describe "#new" do
    let(:subject) { Exhibition.new }

    context "when exhibit object not supplied" do
      it "creates a new collection object" do
        expect(subject.collection.id).to be_nil
      end

      it "creates a new exhibit object" do
        expect(subject.exhibit.id).to be_nil
      end
    end
  end

  describe "#external?" do
    let(:subject) { Exhibition.new }

    it "returns false when exhibit url not present" do
      expect(subject.external?).to be_falsey
    end

    it "returns true when exhibit url present" do
      subject.url = "http://nowhere.com"
      expect(subject.external?).to be_truthy
    end
  end

  describe ".by_collection_id" do
    it "returns exhibitions related to specific collection" do
      Collection.new(name_line_1: "test", unique_id: "abc", preview_mode: 1).save!
      Exhibit.new(url: "http://test", collection: Collection.find(Collection.last.id)).save!
      Collection.new(name_line_1: "test2", unique_id: "def", preview_mode: 1).save!
      Exhibit.new(url: "http://test2", collection: Collection.find(Collection.last.id)).save!
      expect(Exhibition.by_collection_id("def").name_line_1).to eq "test2"
    end
  end

  describe ".all" do
    it "returns all exhibition objects" do
      Collection.new(name_line_1: "test", unique_id: "abc123").save!
      Exhibit.new(url: "http://test", collection: Collection.find(Collection.last.id)).save!
      Exhibit.new(url: "http://test2", collection: Collection.find(Collection.last.id)).save!
      Exhibit.new(collection: Collection.find(Collection.last.id)).save!
      expect(Exhibition.all).to have(2).items
    end
  end

  describe "#save!" do
    let(:subject) { Exhibition.new }

    it "persists a collection record" do
      subject.name_line_1 = "test"
      subject.save!
      collection = Collection.where(name_line_1: "test").take!
      expect(collection.id).to eq Collection.last.id
    end

    it "persists a exhibit record" do
      subject.name_line_1 = "test"
      subject.save!
      exhibit = Exhibit.find(subject.exhibit.id)
      expect(exhibit.id).to eq Exhibit.last.id
    end
  end
end
