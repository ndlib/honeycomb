require "rails_helper"

RSpec.describe Image do
  let(:image_with_spaces) { File.open(Rails.root.join("spec/fixtures", "test copy.jpg"), "r") }

  [:image, :collection, :updated_at, :created_at].each do |field|
    it "has the field #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  [:collection].each do |field|
    it "requires the field, #{field}" do
      expect(subject).to have(1).error_on(field)
    end
  end

  [
    :unprocessed,
    :ready,
    :unavailable,
    :processing
  ].each do |field|
    it "has enum, #{field}" do
      expect(subject).to respond_to("#{field}!")
      expect(subject).to respond_to("#{field}?")
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

  context "foreign key constraints" do
    describe "#destroy" do
      it "fails if a page references it" do
        FactoryGirl.create(:collection)
        subject = FactoryGirl.create(:image, id: 1)
        FactoryGirl.create(:page, image_id: 1)
        expect { subject.destroy }.to raise_error
      end
    end
  end
end
