require "rails_helper"
require "support/item_meta_helpers"

RSpec.configure do |c|
  c.include ItemMetaHelpers, helpers: :item_meta_helpers
end

RSpec.describe GoogleExportItems, helpers: :item_meta_helpers do
  let(:collection) { double(Collection, id: 1) }
  let(:parent1) { instance_double(Item, user_defined_id: "parentid1", collection: collection) }
  let(:items) do
    [
      instance_double(Item, user_defined_id: "id1", collection: collection, parent: parent1, metadata: item_meta_hash_remapped(item_id: 1)),
      instance_double(Item, user_defined_id: "id2", collection: collection, parent: parent1, metadata: item_meta_hash_remapped(item_id: 2)),
      instance_double(Item, user_defined_id: "id3", collection: collection, parent: parent1, metadata: item_meta_hash_remapped(item_id: 3)),
    ]
  end
  let(:item_label_hashes) do
    [
      item_meta_hash_remapped_to_labels(item_id: 1),
      item_meta_hash_remapped_to_labels(item_id: 2),
      item_meta_hash_remapped_to_labels(item_id: 3)
    ]
  end
  let(:item_hashes) do
    [
      item_meta_hash_remapped(item_id: 1),
      item_meta_hash_remapped(item_id: 2),
      item_meta_hash_remapped(item_id: 3),
    ]
  end
  let(:errors) { instance_double(ActiveModel::Errors, full_messages: []) }
  let(:item) { instance_double(Item, valid?: true, changed?: false, new_record?: false, errors: errors, validate: true) }
  let(:item_creator) { instance_double(FindOrCreateItem, using: item, save: true, new_record?: true, item: item) }
  let(:worksheet) { instance_double(GoogleDrive::Worksheet, update_cells: true, save: true) }
  let(:param_hash) { { auth_code: "auth", callback_uri: "callback", items: items, file: "file", sheet: "sheet" } }
  let(:subject) { described_class.call(param_hash) }
  let(:configuration) { double(Metadata::Configuration) }

  before (:each) do
    allow_any_instance_of(GoogleSession).to receive(:connect)
    allow_any_instance_of(GoogleSession).to receive(:get_worksheet).and_return(worksheet)
    allow_any_instance_of(described_class).to receive(:configuration).and_return(configuration)
    allow(RewriteItemMetadataForExport).to receive(:call).and_return(item: "item!")
  end

  it "uses google api to retrieve the worksheet" do
    expect_any_instance_of(GoogleSession).to receive(:get_worksheet).with(file: param_hash[:file], sheet: param_hash[:sheet]).and_return(worksheet)
    subject
  end

  context "collection has items" do
    before (:each) do
      allow(RewriteItemMetadataForExport).to receive(:call) do
        { item: "item!" }
      end
    end

    it "uses GoogleSession to populate the worksheet" do
      expect_any_instance_of(GoogleSession).to receive(:hashes_to_worksheet).with(hash_including(worksheet: worksheet))
      subject
    end

    it "calls RewriteItemMetadataForExport for each item" do
      allow_any_instance_of(GoogleSession).to receive(:hashes_to_worksheet).and_return(true)
      expect(RewriteItemMetadataForExport).to receive(:call).exactly(items.count)
      subject
    end

    it "calls RewriteItemMetadataForExport with the correct item hashes" do
      allow_any_instance_of(GoogleSession).to receive(:hashes_to_worksheet).and_return(true)
      expect(RewriteItemMetadataForExport).to receive(:call).with(hash_including(item_hash: item_meta_hash_remapped(item_id: 1), configuration: configuration))
      expect(RewriteItemMetadataForExport).to receive(:call).with(hash_including(item_hash: item_meta_hash_remapped(item_id: 2), configuration: configuration))
      expect(RewriteItemMetadataForExport).to receive(:call).with(hash_including(item_hash: item_meta_hash_remapped(item_id: 3), configuration: configuration))
      subject
    end

    it "adds a string literal indicator to all values" do
      rewritten_hashes = [{ item: "'item!" }, { item: "'item!" }, { item: "'item!" }]
      expect_any_instance_of(GoogleSession).to receive(:hashes_to_worksheet).with(worksheet: worksheet, hashes: rewritten_hashes)
      subject
    end
  end

  context "collection has no items" do
    let(:items) { [] }
    it "calls GoogleSession to populate the worksheet" do
      expect_any_instance_of(GoogleSession).to receive(:hashes_to_worksheet).with(worksheet: worksheet, hashes: [])
      subject
    end
  end
end
