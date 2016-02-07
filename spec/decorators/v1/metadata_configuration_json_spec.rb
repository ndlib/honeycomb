require "rails_helper"

RSpec.describe V1::MetadataConfigurationJSON do
  let(:collection_configuration) { double(CollectionConfiguration, metadata: {}, facets: {}, sorts: {}) }
  let(:configuration) { Metadata::Configuration.new(collection_configuration) }
  subject { described_class.new(configuration) }

  describe "as_json" do
    it "returns a hash with the fields from the configuration" do
      field = double(as_json: "json", name: "name")
      allow(configuration).to receive(:fields).and_return([field])
      expect(subject.as_json[:fields]).to eq("name" => "json")
    end

    it "adds the @context field" do
      expect(subject.as_json["@context"]).to eq("http://schema.org")
    end

    it "adds the @type field" do
      expect(subject.as_json["@type"]).to eq("DECMetadataConfiguration")
    end
  end

  describe "to_json" do
    it "returns a json representation of the file" do
      expect(subject).to receive(:as_json).and_return("json" => "json!")
      expect(subject.to_json).to eq("{\"json\":\"json!\"}")
    end

    it "calls to json on the as_json hash" do
      test_value = "json"
      expect(test_value).to receive(:to_json).and_return("json")
      allow(subject).to receive(:as_json).and_return(test_value)

      subject.to_json
    end
  end
end
