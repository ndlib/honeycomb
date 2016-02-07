require "rails_helper"
require "support/item_meta_helpers"

RSpec.configure do |c|
  c.include ItemMetaHelpers, helpers: :item_meta_helpers
end

RSpec.describe GoogleCreateItems, helpers: :item_meta_helpers do
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
  let(:errors) { instance_double(ActiveModel::Errors, full_messages: []) }
  let(:item) { instance_double(Item, valid?: true, changed?: false, new_record?: false, errors: errors, validate: true) }
  let(:item_creator) { instance_double(FindOrCreateItem, using: item, save: true, new_record?: true, item: item) }
  let(:worksheet) { instance_double(GoogleDrive::Worksheet) }
  let(:param_hash) { { auth_code: "auth", callback_uri: "callback", collection_id: 1, file: "file", sheet: "sheet" } }
  let(:configuration) { double(Metadata::Configuration, field_names: [], label?: "label", label: double(name: :name, multiple: true, type: :string)) }

  let(:subject) { described_class.call(param_hash) }

  before (:each) do
    allow_any_instance_of(GoogleSession).to receive(:connect)
    allow_any_instance_of(GoogleSession).to receive(:get_worksheet).and_return(worksheet)
    allow_any_instance_of(GoogleSession).to receive(:worksheet_to_hash).and_return(items)
    allow(FindOrCreateItem).to receive(:new).and_return(item_creator)
    allow(SaveItem).to receive(:call).and_return true
    allow_any_instance_of(described_class).to receive(:configuration).and_return(configuration)
  end

  it "throws an exception if a label is not found" do
    items[0][:InvalidFieldName] = "invalid value"
    expect(subject).to include(:errors)
  end

  it "uses google api to retrieve the worksheet" do
    expect_any_instance_of(GoogleSession).to receive(:get_worksheet).with(file: param_hash[:file], sheet: param_hash[:sheet]).and_return(worksheet)
    subject
  end

  it "gets the rows of the worksheet" do
    expect_any_instance_of(GoogleSession).to receive(:worksheet_to_hash).and_return({})
    subject
  end

  it "calls CreateItems with the hash read from the worksheet" do
    allow_any_instance_of(GoogleSession).to receive(:worksheet_to_hash).and_return([{ item: "item" }])
    creator = GoogleCreateItems.new(auth_code: param_hash[:auth_code], callback_uri: param_hash[:callback_uri])
    expect(CreateItems).to receive(:call).with(hash_including(items_hash: [{ item: "item" }]))
    creator.create_from_worksheet!(collection_id: param_hash[:collection_id], file: param_hash[:file], sheet: param_hash[:sheet])
  end

  context "worksheet has items" do
    it "injects a RewriteItemMetadata call to properly map user data to valid item data" do
      allow_any_instance_of(GoogleSession).to receive(:worksheet_to_hash).and_return(items)
      creator = GoogleCreateItems.new(auth_code: param_hash[:auth_code], callback_uri: param_hash[:callback_uri])
      expect(RewriteItemMetadata).to receive(:call).with(item_hash: items[0], errors: [], configuration: configuration).and_return({})
      expect(RewriteItemMetadata).to receive(:call).with(item_hash: items[1], errors: [], configuration: configuration).and_return({})
      expect(RewriteItemMetadata).to receive(:call).with(item_hash: items[2], errors: [], configuration: configuration).and_return({})
      creator.create_from_worksheet!(collection_id: param_hash[:collection_id], file: param_hash[:file], sheet: param_hash[:sheet])
    end

    it "returns a hash with summary" do
      allow_any_instance_of(GoogleSession).to receive(:worksheet_to_hash).and_return(items)
      creator = GoogleCreateItems.new(auth_code: param_hash[:auth_code], callback_uri: param_hash[:callback_uri])
      results = creator.create_from_worksheet!(collection_id: param_hash[:collection_id], file: param_hash[:file], sheet: param_hash[:sheet])
      expected = { summary: { total_count: 3, valid_count: 3, new_count: 3, error_count: 0, changed_count: 0, unchanged_count: 0 } }
      expect(results).to include(expected)
    end

    it "returns a hash with errors" do
      allow_any_instance_of(GoogleSession).to receive(:worksheet_to_hash).and_return(items)
      creator = GoogleCreateItems.new(auth_code: param_hash[:auth_code], callback_uri: param_hash[:callback_uri])
      results = creator.create_from_worksheet!(collection_id: param_hash[:collection_id], file: param_hash[:file], sheet: param_hash[:sheet])
      expect(results).to include(:errors)
    end
  end

  context "worksheet has no items" do
    it "returns a hash with summary" do
      allow_any_instance_of(GoogleSession).to receive(:worksheet_to_hash).and_return([])
      creator = GoogleCreateItems.new(auth_code: param_hash[:auth_code], callback_uri: param_hash[:callback_uri])
      results = creator.create_from_worksheet!(collection_id: param_hash[:collection_id], file: param_hash[:file], sheet: param_hash[:sheet])
      expected = { summary: { total_count: 0, valid_count: 0, new_count: 0, error_count: 0, changed_count: 0, unchanged_count: 0 } }
      expect(results).to include(expected)
    end

    it "returns a hash with errors" do
      allow_any_instance_of(GoogleSession).to receive(:worksheet_to_hash).and_return([])
      creator = GoogleCreateItems.new(auth_code: param_hash[:auth_code], callback_uri: param_hash[:callback_uri])
      results = creator.create_from_worksheet!(collection_id: param_hash[:collection_id], file: param_hash[:file], sheet: param_hash[:sheet])
      expect(results).to include(errors: [])
    end
  end
end
