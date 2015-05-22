require "rails_helper"

RSpec.describe Showcase do
  [:name_line_1, :description, :unique_id, :image, :exhibit, :sections, :published, :collection].each do |field|
    it "has the field #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  [:exhibit, :name_line_1].each do |field|
    it "requires the field, #{field}" do
      expect(subject).to have(1).error_on(field)
    end
  end

  it "has paper trail" do
    expect(subject).to respond_to(:versions)
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

  describe "#name" do
    it "concatinates name_line_1 and name_line_2 if there is a name_line_2" do
      expect(subject).to receive(:name_line_1).and_return("name line 1")
      expect(subject).to receive(:name_line_2).twice.and_return("name line 2")

      expect(subject.name).to eq("name line 1 name line 2")
    end

    it "does not concatintate name_line_2 if there is no name_line_2" do
      expect(subject).to receive(:name_line_1).and_return("name line 1")
      expect(subject).to receive(:name_line_2).and_return(nil)

      expect(subject.name).to eq("name line 1")
    end
  end

  describe "#beehive_url" do
    it "is a url to the beehive server" do
      subject.collection = Collection.new
      expect(subject.beehive_url).to include(Rails.configuration.settings.beehive_url)
    end

    it "uses name_line_1 for the slug" do
      subject.name_line_1 = "Slug"
      expect(subject.slug).to eq(subject.name_line_1)
    end
  end
end
