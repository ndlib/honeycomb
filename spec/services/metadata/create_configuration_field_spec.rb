require "rails_helper"

RSpec.describe Metadata::CreateConfigurationField do
  let(:configuration) { double(Metadata::Configuration) }
  let(:collection) { double(Collection) }
  let(:unique_key) { Metadata::GenerateUniqueKey.call }
  let(:data) { { name: "My Name" } }

  before(:each) do
    allow_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(configuration)
    allow(configuration).to receive(:save_field)
    allow(Metadata::ConfigurationInputCleaner).to receive(:call).and_return(data)
    allow_any_instance_of(Metadata::CreateConfigurationField).to receive(:duplicate_label?).and_return(false)
    allow(Metadata::GenerateUniqueKey).to receive(:call).and_return(unique_key)
    allow_any_instance_of(CollectionConfigurationQuery).to receive(:max_metadata_order).and_return(0)
  end

  context "when label is unique" do
    it "calls save_field on the configuration" do
      expect(configuration).to receive(:save_field).with(unique_key, data)
      described_class.call(collection, data)
    end

    it "calls the cleaner on the input data" do
      expect(Metadata::ConfigurationInputCleaner).to receive(:call).with(data)
      described_class.call(collection, data)
    end

    it "uses CollectionConfigurationQuery to get a default order when one is not present" do
      data.delete(:order)
      expect_any_instance_of(CollectionConfigurationQuery).to receive(:max_metadata_order).and_return(0)
      described_class.call(collection, data)
    end

    it "doesn't call CollectionConfigurationQuery to get the max order when one is given" do
      data[:order] = 10
      expect_any_instance_of(CollectionConfigurationQuery).not_to receive(:max_metadata_order)
      described_class.call(collection, data)
    end

    it "uses the order given when one is present" do
      data[:order] = 10
      described_class.call(collection, data)
      expect(data[:order]).to eq(10)
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

  context "when label is not unique" do
    before(:each) do
      allow_any_instance_of(Metadata::CreateConfigurationField).to receive(:duplicate_label?).and_return(true)
    end

    it "returns duplicate_found" do
      expect(described_class.call(collection, data)).to be_nil
    end

    it "does not save_field on the configuration" do
      expect(configuration).to_not receive(:save_field).with(unique_key, data)
      described_class.call(collection, data)
    end

    it "calls the cleaner on the input data" do
      expect(Metadata::ConfigurationInputCleaner).to receive(:call).with(data)
      described_class.call(collection, data)
    end

    it "populates a default value for active when one is not present" do
      data.delete(:active)
      described_class.call(collection, data)
      expect(data[:active]).to eq(true)
    end
  end
end
