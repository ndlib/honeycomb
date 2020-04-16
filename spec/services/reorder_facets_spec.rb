require "rails_helper"

describe ReorderFacets do
  subject { described_class.call(collection, new_order) }

  let(:collection) { double(Collection) }
  let(:new_order) { { "0" => { "name" => "facetName", "order" => 1 } } }
  let(:configuration) { double(Metadata::Configuration, facet: "facetName", save_facet: true) }

  before(:each) do
    allow_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(configuration)
  end

  it "passes the data to configuration save_facet " do
    expect(configuration).to receive(:save_facet).with("facetName", "order" => 1)
    subject
  end

  it "does not call save_facet if the facet value is not found" do
    allow(configuration).to receive(:facet).and_return(false)
    subject
  end

  it "calls facet with the name passed in" do
    expect(configuration).to receive(:facet).with(new_order["0"]["name"])
    subject
  end
end
