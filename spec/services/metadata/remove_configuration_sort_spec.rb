require "rails_helper"

RSpec.describe Metadata::RemoveConfigurationSort do
  let(:configuration) { double(Metadata::Configuration) }
  let(:collection) { double(Collection) }

  before(:each) do
    allow_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(configuration)
    allow(configuration).to receive(:save_sort)
  end

  it "calls save_sort on the configuration with nil data" do
    expect(configuration).to receive(:save_sort).with(:sort_name, nil)
    described_class.call(collection, :sort_name)
  end
end
