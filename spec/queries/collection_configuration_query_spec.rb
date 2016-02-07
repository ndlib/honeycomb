require "rails"

describe CollectionConfigurationQuery do
  subject { described_class.new(collection) }
  let(:collection) { double(Collection, collection_configuration: collection_configuration) }
  let(:collection_configuration) { double }

  it "passes the current collection's config to the Metadata::Configuration" do
    expect(Metadata::Configuration).to receive(:new).with(collection_configuration)
    subject.find
  end
end
