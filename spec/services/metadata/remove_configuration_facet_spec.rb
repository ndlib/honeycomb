require "rails_helper"

RSpec.describe Metadata::RemoveConfigurationFacet do
  let(:configuration) { double(Metadata::Configuration) }
  let(:collection) { double(Collection) }

  before(:each) do
    allow_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(configuration)
    allow(configuration).to receive(:save_facet)
  end

  it "calls save_facet on the configuration with nil data" do
    expect(configuration).to receive(:save_facet).with(:facet_name, nil)
    described_class.call(collection, :facet_name)
  end
end
