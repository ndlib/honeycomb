require "rails_helper"

RSpec.describe Media do
  [:id, :uuid, :collection, :items, :updated_at, :created_at].each do |field|
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

  it "has a papertrail" do
    expect(subject).to respond_to(:paper_trail_enabled_for_model?)
    expect(subject.paper_trail_enabled_for_model?).to be(true)
  end

  it "delegates to_json to a serializer if one is given" do
    serializer = {}
    allow(subject).to receive(:serializer).and_return(serializer)
    allow(serializer).to receive(:to_json).and_return("serializer.to_json")
    expect(subject.to_json).to eq("serializer.to_json")
  end
end
