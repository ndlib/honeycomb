require "rails_helper"

RSpec.describe Collection do
  [:name_line_1, :name_line_2, :items, :description, :unique_id, :showcases, :exhibit, :collection_users, :users, :updated_at, :created_at].each do |field|
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  it "requires the name_line_1 field " do
    expect(subject).to have(1).error_on(:name_line_1)
  end

  it "has paper trail" do
    expect(subject).to respond_to(:versions)
  end

  describe "#beehive_url" do
    it "is a url to the beehive server" do
      expect(subject.beehive_url).to include(Rails.configuration.settings.beehive_url)
    end

    it "uses name for the slug" do
      subject.name_line_1 = "Slug"
      expect(subject.slug).to eq(subject.name_line_1)
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
end
