require "rails_helper"

RSpec.describe V1::MetadataJSON do
  let(:item) { instance_double(Item, item_metadata: item_metadata) }
  let(:collection_configuration) { double(Metadata::Configuration, field: metadata_config) }
  let(:instance) { described_class.new(item) }

  let(:item_metadata) { double(Metadata::Retrieval, fields: item_metadata_fields) }
  let(:item_metadata_fields) { { "name" => [metadata_string] } }
  let(:metadata_string) { double(MetadataString, to_hash: "HASH") }
  let(:metadata_config) { double(name: "Name", label: "Label", type: :string) }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:configuration).and_return(collection_configuration)
  end

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

    it "builds a hash out of the metadata" do
      # allow(item).to receive(:name).and_return("name")
      # expect_any_instance_of(MetadataString).to receive(:to_hash).and_return("hash")
      expect(subject).to eq("name" => { "@type" => "MetadataField", "name" => "Name", "label" => "Label", "values" => ["HASH"] })
    end

    it "retreives the name from config" do
      expect(metadata_config).to receive(:name).and_return("newname")
      expect(subject["name"]["name"]).to eq("newname")
    end

    it "retreives the label from config" do
      expect(metadata_config).to receive(:label).and_return("newname")
      expect(subject["name"]["label"]).to eq("newname")
    end

    it "calls to hash on the metadata field" do
      expect(metadata_string).to receive(:to_hash)
      subject
    end

    it "loads the field config from collection_configuration" do
      expect(collection_configuration).to receive(:field).and_return(metadata_config)
      subject
    end

    it "does not add the field if there is no config" do
      allow(collection_configuration).to receive(:field).with("name").and_return(nil)
      expect(subject).to eq({})
    end
  end
end
