require "rails_helper"
require "support/item_meta_helpers"

RSpec.configure do |c|
  c.include ItemMetaHelpers, helpers: :item_meta_helpers
end

RSpec.describe CsvCreateItems, helpers: :item_meta_helpers do
  let(:items) do
    [
      item_meta_hash(item_id: 1),
      item_meta_hash(item_id: 2),
      item_meta_hash(item_id: 3),
    ]
  end
  let(:remapped_items) do
    [
      item_meta_hash_remapped(item_id: 1),
      item_meta_hash_remapped(item_id: 2),
      item_meta_hash_remapped(item_id: 3),
    ]
  end
  let(:file) { instance_double(ActionDispatch::Http::UploadedFile, path: "file path") }
  let(:file_contents) { instance_double(String, valid_encoding?: true) }
  let(:errors) { instance_double(ActiveModel::Errors, full_messages: []) }
  let(:metadata_fields) { instance_double(Metadata::Fields, errors: errors) }
  let(:item) { instance_double(Item, valid?: true, changed?: false, new_record?: false, errors: errors, item_metadata: metadata_fields, validate: true) }
  let(:item_creator) { instance_double(FindOrCreateItem, using: item, save: true, new_record?: true, changed?: false, item: item) }
  let(:param_hash) { { collection: collection, file: file } }
  let(:configuration) do
    double(
      Metadata::Configuration,
      field?: true,
      field_names: [],
      label?: "label",
      label: double(name: :name, multiple: true, type: :string)
    )
  end
  let(:collection) { instance_double(Collection, id: 1) }
  let(:subject) { described_class.call(param_hash) }

  before(:each) do
    allow(File).to receive(:read).and_return(file_contents)
    allow(FindOrCreateItem).to receive(:new).and_return(item_creator)
    allow(SaveItem).to receive(:call).and_return true
    allow(Index::Collection).to receive(:index!).and_return true
    allow_any_instance_of(described_class).to receive(:collection_configuration).and_return(configuration)
  end

  it "throws an exception if a label is not found" do
    allow(CSV).to receive(:parse).and_return([{ item: "item" }])
    items[0][:InvalidFieldName] = "invalid value"
    expect(subject).to include(:errors)
  end

  it "calls CreateItems with the hash read from the csv" do
    allow(CSV).to receive(:parse).and_return([{ item: "item" }])
    expect(CreateItems).to receive(:call).with(hash_including(items_hash: [{ item: "item" }]))
    subject
  end

  it "renders an error when the file is not UTF-8 encoded" do
    allow(file_contents).to receive(:valid_encoding?).and_return(false)
    expect(subject).to include(:errors)
  end

  context "when csv has items" do
    it "injects a RewriteItemMetadata call to properly map user data to valid item data" do
      allow(CSV).to receive(:parse).and_return(items)
      expect(RewriteItemMetadata).to receive(:call).with(item_hash: items[0], errors: [], configuration: configuration).and_return({})
      expect(RewriteItemMetadata).to receive(:call).with(item_hash: items[1], errors: [], configuration: configuration).and_return({})
      expect(RewriteItemMetadata).to receive(:call).with(item_hash: items[2], errors: [], configuration: configuration).and_return({})
      subject
    end

    it "returns a hash with summary" do
      allow(CSV).to receive(:parse).and_return(items)
      expected = { summary: { total_count: 3, valid_count: 3, new_count: 3, error_count: 0, changed_count: 0, unchanged_count: 0 } }
      expect(subject).to include(expected)
    end

    it "returns a hash with errors" do
      allow(CSV).to receive(:parse).and_return(items)
      expect(subject).to include(:errors)
    end
  end

  context "worksheet has no items" do
    it "returns a hash with summary" do
      allow(CSV).to receive(:parse).and_return([])
      expected = { summary: { total_count: 0, valid_count: 0, new_count: 0, error_count: 0, changed_count: 0, unchanged_count: 0 } }
      expect(subject).to include(expected)
    end

    it "returns a hash with errors" do
      allow(CSV).to receive(:parse).and_return([])
      expect(subject).to include(errors: [])
    end
  end
end
