require "rails_helper"

RSpec.describe SaveMetadata, type: :model do
  subject { described_class.call(item, params) }
  let(:item) { double(Item, item_metadata: item_metadata, save: true) }
  let(:params) { { name: "name" } }
  let(:item_metadata) { double(valid?: true) }

  before(:each) do
    allow(Metadata::Setter).to receive(:call).and_return(true)
    allow(Index::Item).to receive(:index!)
  end

  it "sets the metadata with the metadata setter" do
    expect(Metadata::Setter).to receive(:call).with(item, params).and_return(true)
    subject
  end

  it "calls item#save if the item_metadata is valid? " do
    allow(item_metadata).to receive(:valid?).and_return(true)
    expect(item).to receive(:save).and_return(true)
    subject
  end

  it "does not call item#save if the item_metadata is not valid?" do
    allow(item_metadata).to receive(:valid?).and_return(false)
    expect(item).to_not receive(:save)
    subject
  end

  it "returns the item_metadata if the process is successful" do
    expect(subject).to eq(item_metadata)
  end

  it "returns false if the the item_metadata is not valid?" do
    allow(item_metadata).to receive(:valid?).and_return(false)
    expect(subject).to eq(false)
  end

  it "returns false if the the item save is false" do
    allow(item).to receive(:save).and_return(false)
    expect(subject).to eq(false)
  end

  it "calls the metadata params cleaner on the input" do
    expect(ParamCleaner).to receive(:call).with(hash: params).ordered
    subject
  end

  it "calls the indexer on success" do
    expect(Index::Item).to receive(:index!).with(item)
    subject
  end

  it "does not call the indexer on failure" do
    allow(item_metadata).to receive(:valid?).and_return(false)
    expect(Index::Item).to_not receive(:index!)
    subject
  end
end
