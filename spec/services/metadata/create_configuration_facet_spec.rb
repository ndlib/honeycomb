require "rails_helper"

RSpec.describe Metadata::CreateConfigurationFacet do
  let(:configuration) { double(Metadata::Configuration) }
  let(:collection) { double(Collection) }
  let(:unique_key) { 'facetName' }
  let(:data) { { name: nil, field_name: 'facetName', unlimited: true } }

  before(:each) do
    allow_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(configuration)
    allow(configuration).to receive(:save_facet)
    allow(Metadata::ConfigurationInputCleaner).to receive(:call).and_return(data)
    allow_any_instance_of(Metadata::CreateConfigurationFacet).to receive(:duplicate_name?).and_return(false)
  end

  context "when name is unique" do
    it "calls save_facet on the configuration" do
      expect(configuration).to receive(:save_facet).with(unique_key, data)
      described_class.call(collection, data)
    end

    it "calls the cleaner on the input data" do
      expect(Metadata::ConfigurationInputCleaner).to receive(:call).with(data)
      described_class.call(collection, data)
    end

    it "gets a default limit when one is not present" do
      data.delete(:limit)
      described_class.call(collection, data)
      expect(data[:limit]).to be >= 0
    end

    it "uses the limit given when one is present" do
      data[:limit] = 10
      described_class.call(collection, data)
      expect(data[:limit]).to eq(10)
    end

    it "populates a default value for active when one is not present" do
      data.delete(:active)
      described_class.call(collection, data)
      expect(data[:active]).to eq(true)
    end

    it "uses the value given for active when one is present" do
      data[:active] = false
      described_class.call(collection, data)
      expect(data[:active]).to eq(false)
    end
  end

  context "when name is not unique" do
    before(:each) do
      allow_any_instance_of(Metadata::CreateConfigurationFacet).to receive(:duplicate_name?).and_return(true)
    end

    it "returns duplicate_found" do
      expect(described_class.call(collection, data)).to be_nil
    end

    it "does not save_facet on the configuration" do
      expect(configuration).to_not receive(:save_facet).with(unique_key, data)
      described_class.call(collection, data)
    end
  end
end
