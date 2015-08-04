require "rails_helper"

RSpec.describe V1::MetadataJSON do
  let(:item) { Item.new }
  let(:instance) { described_class.new(item) }

  describe "self.metadata" do
    subject { described_class.metadata(item) }

    it "calls metadata on a new instance" do
      expect(described_class).to receive(:new).with(item).and_call_original
      expect_any_instance_of(described_class).to receive(:metadata).and_return("metadata")
      expect(subject).to eq("metadata")
    end
  end

  describe "#metadata" do
    subject { instance.metadata }

    it "calls the MetadataString class for string metadata" do
      allow(item).to receive(:name).and_return("name")
      expect_any_instance_of(MetadataString).to receive(:to_hash).and_return("hash")
      expect(subject).to eq(name: { "@type" => "MetadataField", "name" => :name, "label" => "Name", "values" => ["hash"] })
    end

    it "calls the MetadataHTML class for html metadata" do
      allow(item).to receive(:description).and_return("desc")
      expect_any_instance_of(MetadataHTML).to receive(:to_hash).and_return("hash")
      expect(subject).to eq(description: { "@type" => "MetadataField", "name" => :description, "label" => "Description", "values" => ["hash"] })
    end

    it "calls the MetadataDate class for date metadata" do
      allow(item).to receive(:date_modified).and_return(year: "2010")
      expect_any_instance_of(MetadataDate).to receive(:to_hash).and_return("hash")
      expect(subject).to eq(date_modified: { "@type" => "MetadataField", "name" => :date_modified, "label" => "Date Modified", "values" => ["hash"] })
    end

    it "errors on an unexpected field type" do
      item.name = "name"
      expect_any_instance_of(Metadata::Configuration::Field).to receive(:type).and_return("faketype")
      expect { subject }.to raise_error("missing type")
    end

    it "returns multiple values for arrays" do
      string1 = instance_double(MetadataString)
      string2 = instance_double(MetadataString)
      expect(MetadataString).to receive(:new).and_return(string1, string2)
      expect(string1).to receive(:to_hash).and_return("hash 1")
      expect(string2).to receive(:to_hash).and_return("hash 2")
      allow(item).to receive(:name).and_return(["name 1", "name 2"])
      expect(subject).to include(name: hash_including("values" => ["hash 1", "hash 2"]))
    end
  end
end
