require "rails_helper"

RSpec.describe SaveMetadata, type: :model do
  subject { described_class.call(item, params) }
  let(:item) { double(Item, item_metadata: item_metadata, save: true) }
  let(:params) { { name: "name" } }
  let(:item_metadata) { double(valid?: true) }

  before(:each) do
    allow(Metadata::Setter).to receive(:call).and_return(true)
  end

  it "sets the metadata with the metadata setter" do
    expect(Metadata::Setter).to receive(:call).with(item, params).and_return(true)
    subject
  end

  it "does not set the metadata if the params are nil" do
    expect(Metadata::Setter).to_not receive(:call).with(params)
    params = nil
    subject
  end

  it "calls item#save if the item_metadata is valid? " do
    expect(item_metadata).to receive(:valid?).and_return(true)
    expect(item).to receive(:save).and_return(true)
    subject
  end

  it "does not call item#save if the item_metadata is not valid?" do
    expect(item_metadata).to receive(:valid?).and_return(false)
    expect(item).to_not receive(:save)
    subject
  end

  it "returns the item_metadata if the process is successful" do
    expect(subject).to eq(item_metadata)
  end

  it "returns false if the the item_metadata is not valid?" do
    expect(item_metadata).to receive(:valid?).and_return(false)
    expect(subject).to eq(false)
  end

  it "returns false if the the item save is false" do
    expect(item).to receive(:save).and_return(false)
    expect(subject).to eq(false)
  end
end
