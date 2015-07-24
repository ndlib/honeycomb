require "rails_helper"

RSpec.describe Item do
  let(:image_with_spaces) { File.open(Rails.root.join("spec/fixtures", "test copy.jpg"), "r") }

  [
    :name,
    :description,
    :transcription,
    :collection,
    :honeypot_image,
    :published,
    :unique_id,
    :creator,
    :publisher,
    :alternate_name,
    :rights,
    :original_language,
    :date_created,
    :date_modified,
    :date_published,
  ].each do |field|
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  it "requires the name field " do
    expect(subject).to have(1).error_on(:name)
  end

  it "requires the collection field" do
    expect(subject).to have(1).error_on(:collection)
  end

  describe "#manuscript_url" do
    it "is not required" do
      expect(subject).to have(0).errors_on(:manuscript_url)
    end

    it "is valid with a url" do
      subject.manuscript_url = "http://example.com/manuscript"
      expect(subject).to have(0).errors_on(:manuscript_url)
    end

    it "is invalid with a non url value" do
      subject.manuscript_url = "manuscript"
      expect(subject).to have(1).error_on(:manuscript_url)
    end
  end

  describe "date metadata" do
    it "validates date created" do
      subject.date_created = { year: nil }
      expect(subject).to have(1).error_on(:date_created)
    end

    it "validates date modified" do
      subject.date_modified = { year: nil }
      expect(subject).to have(1).error_on(:date_modified)
    end

    it "validates date published" do
      subject.date_published = { year: nil }
      expect(subject).to have(1).error_on(:date_published)
    end
  end

  it "has a papertrail" do
    expect(subject).to respond_to(:paper_trail_enabled_for_model?)
    expect(subject.paper_trail_enabled_for_model?).to be(true)
  end

  it "keeps spaces in the original filename" do
    subject.image = image_with_spaces
    expect(subject.image.original_filename).to eq("test copy.jpg")
  end

  it "has a parent" do
    expect(subject).to respond_to(:parent)
    expect(subject.parent).to be_nil
  end

  it "has children" do
    expect(subject).to respond_to(:children)
    expect(subject.children).to eq([])
  end

  it "has sections" do
    expect(subject).to respond_to(:sections)
    expect(subject.sections).to eq([])
  end

  it "has showcases" do
    expect(subject).to respond_to(:showcases)
    expect(subject.showcases).to eq([])
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

  context "foreign key constraints" do
    describe "#destroy" do
      it "fails if a section references it" do
        FactoryGirl.create(:collection)
        FactoryGirl.create(:exhibit)
        FactoryGirl.create(:showcase)
        subject = FactoryGirl.create(:item)
        FactoryGirl.create(:section, id: 1, item_id: 1)
        expect { subject.destroy }.to raise_error
      end

      it "fails if a child item references it" do
        FactoryGirl.create(:collection)
        FactoryGirl.create(:exhibit)
        FactoryGirl.create(:showcase)
        subject = FactoryGirl.create(:item)
        FactoryGirl.create(:item, id: 2, parent_id: 1)
        expect { subject.destroy }.to raise_error
      end
    end
  end
end
