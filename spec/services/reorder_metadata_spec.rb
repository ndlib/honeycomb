require "rails_helper"

describe ReorderMetadata do
  subject { described_class.call(collection, new_order) }

  let(:collection) { double(Collection) }
  let(:new_order) { { "0" => { "name" => "field", "order" => 1 } } }
  let(:configuration) { double(Metadata::Configuration, field: "field", save_field: true) }

  before(:each) do
    allow_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(configuration)
  end

  it "passes the data to configuration save_field " do
    expect(configuration).to receive(:save_field).with("field", "order" => 1)
    subject
  end

  it "does not call save_field if the field is not found" do
    allow(configuration).to receive(:field).and_return(false)
    subject
  end

  it "calls field with the name passed in" do
    expect(configuration).to receive(:field).with(new_order["0"]["name"])
    subject
  end
end
