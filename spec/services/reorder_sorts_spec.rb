require "rails_helper"

describe ReorderSorts do
  subject { described_class.call(collection, new_order) }

  let(:collection) { double(Collection) }
  let(:new_order) { { "0" => { "name" => "sortName", "order" => 1 } } }
  let(:configuration) { double(Metadata::Configuration, sort: "sortName", save_sort: true) }

  before(:each) do
    allow_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(configuration)
  end

  it "passes the data to configuration save_sort " do
    expect(configuration).to receive(:save_sort).with("sortName", "order" => 1)
    subject
  end

  it "does not call save_sort if the sort value is not found" do
    allow(configuration).to receive(:sort).and_return(false)
    subject
  end

  it "calls sort with the name passed in" do
    expect(configuration).to receive(:sort).with(new_order["0"]["name"])
    subject
  end
end
