require "rails_helper"
require "support/item_meta_helpers"

RSpec.configure do |c|
  c.include ItemMetaHelpers, helpers: :item_meta_helpers
end

RSpec.describe CreateItems, helpers: :item_meta_helpers do
  let(:items) do
    [
      item_meta_hash_remapped(item_id: 1),
      item_meta_hash_remapped(item_id: 2),
      item_meta_hash_remapped(item_id: 3)
    ]
  end
  let(:item_errors) { instance_double(ActiveModel::Errors, full_messages: ["Item validation error"]) }
  let(:errors) { [] }
  let(:counts) do
    {
      total_count: 0,
      valid_count: 0,
      new_count: 0,
      error_count: 0,
      changed_count: 0,
      unchanged_count: 0
    }
  end
  let(:creator) { instance_double(FindOrCreateItem, using: item, new_record?: true, changed?: false, save: true, item: item) }
  let(:metadata_fields) { instance_double(Metadata::Fields, errors: item_errors) }
  let(:item) { instance_double(Item, valid?: true, changed?: false, new_record?: false, errors: item_errors, item_metadata: metadata_fields) }
  let(:subject) do
    described_class.call(collection_id: 1, find_by: [], items_hash: items, counts: counts, errors: errors)
  end

  before (:each) do
    allow(Item).to receive(:new).and_return(item)
    allow(Item).to receive(:find_or_create_by).and_return(item)
    allow(SaveItem).to receive(:call).and_return true
    allow(FindOrCreateItem).to receive(:new).and_return(creator)
  end

  it "allows injecting a block to edit the properties before creating the item" do
    rewritten = items.each { |item_hash| { item_name: item_hash[:name] } }
    expect(FindOrCreateItem).to receive(:new).with(props: { collection_id: 1, item_name: rewritten[0][:name] }).and_return(creator).ordered
    expect(FindOrCreateItem).to receive(:new).with(props: { collection_id: 1, item_name: rewritten[1][:name] }).and_return(creator).ordered
    expect(FindOrCreateItem).to receive(:new).with(props: { collection_id: 1, item_name: rewritten[2][:name] }).and_return(creator).ordered
    described_class.call(collection_id: 1, find_by: [], items_hash: items, counts: counts, errors: errors) do |item_props, _rewrite_errors|
      { item_name: item_props[:name] }
    end
  end

  context "when it receives errors from the injected block" do
    let(:subject) do
      described_class.call(collection_id: 1, find_by: [], items_hash: items, counts: counts, errors: errors) do |item_props, rewrite_errors|
        rewrite_errors << ["Rewrite error 1 on #{item_props[:name]}", "Rewrite error 2 on #{item_props[:name]}"]
        item_props
      end
    end

    it "adds these errors to the items" do
      expected_errors = [
        { errors: [["Rewrite error 1 on name1", "Rewrite error 2 on name1"], "Item validation error"], item: item },
        { errors: [["Rewrite error 1 on name2", "Rewrite error 2 on name2"], "Item validation error"], item: item },
        { errors: [["Rewrite error 1 on name3", "Rewrite error 2 on name3"], "Item validation error"], item: item }
      ]
      subject
      expect(errors).to eq(expected_errors)
    end

    it "does not try to save the item" do
      expect(SaveItem).not_to receive(:call)
      subject
    end

    it "counts these as overall errors" do
      expected = { total_count: 3, valid_count: 0, new_count: 0, error_count: 3, changed_count: 0, unchanged_count: 0 }
      subject
      expect(counts).to include(expected)
    end
  end

  context "called with items" do
    it "uses FindOrCreateItem to create the item with the given properties" do
      allow(CreateUniqueId).to receive(:call).and_return(true)
      expect(FindOrCreateItem).to receive(:new).with(props: hash_including(items[0])).ordered
      expect(FindOrCreateItem).to receive(:new).with(props: hash_including(items[1])).ordered
      expect(FindOrCreateItem).to receive(:new).with(props: hash_including(items[2])).ordered
      subject
    end

    it "uses FindOrCreateItem service to save all items" do
      allow(item).to receive(:assign_attributes).and_return(true)
      allow(CreateUniqueId).to receive(:call).and_return(true)
      expect(creator).to receive(:save).exactly(3).and_return true
      subject
    end

    context "that validate successfully as new items" do
      let(:item_errors) { instance_double(ActiveModel::Errors, full_messages: []) }
      let(:metadata_fields) { instance_double(Metadata::Fields, errors: item_errors) }
      let(:item) do
        instance_double(Item, valid?: true, changed?: false, new_record?: false, errors: item_errors, item_metadata: metadata_fields, validate: true)
      end

      it "returns correct summary" do
        expected = { total_count: 3, valid_count: 3, new_count: 3, error_count: 0, changed_count: 0, unchanged_count: 0 }
        subject
        expect(counts).to include(expected)
      end

      it "returns no errors" do
        subject
        expect(errors).to eq([])
      end
    end

    context "that validate successfully as changed items" do
      let(:item_errors) { instance_double(ActiveModel::Errors, full_messages: []) }
      let(:creator) { instance_double(FindOrCreateItem, using: item, new_record?: false, changed?: true, save: true, item: item) }
      let(:metadata_fields) { instance_double(Metadata::Fields, errors: item_errors) }
      let(:item) do
        instance_double(Item, valid?: true, changed?: false, new_record?: false, errors: item_errors, item_metadata: metadata_fields, validate: true)
      end

      it "returns correct summary" do
        expected = { total_count: 3, valid_count: 3, new_count: 0, error_count: 0, changed_count: 3, unchanged_count: 0 }
        subject
        expect(counts).to include(expected)
      end

      it "returns no errors" do
        subject
        expect(errors).to eq([])
      end
    end

    context "that validate successfully as unchanged items" do
      let(:item_errors) { instance_double(ActiveModel::Errors, full_messages: []) }
      let(:creator) { instance_double(FindOrCreateItem, using: item, new_record?: false, changed?: false, save: true, item: item) }
      let(:metadata_fields) { instance_double(Metadata::Fields, errors: item_errors) }
      let(:item) do
        instance_double(Item, valid?: true, changed?: false, new_record?: false, errors: item_errors, item_metadata: metadata_fields, validate: true)
      end

      it "returns correct summary" do
        expected = { total_count: 3, valid_count: 3, new_count: 0, error_count: 0, changed_count: 0, unchanged_count: 3 }
        subject
        expect(counts).to include(expected)
      end

      it "returns no errors" do
        subject
        expect(errors).to eq([])
      end
    end

    context "that do not validate successfully" do
      let(:creator) { instance_double(FindOrCreateItem, using: item, new_record?: true, changed?: false, valid?: false, save: false, item: item) }
      let(:item_errors) { instance_double(ActiveModel::Errors, full_messages: ["Item validation error"]) }
      let(:metadata_fields) { instance_double(Metadata::Fields, errors: item_errors) }
      let(:item) { instance_double(Item, valid?: false, changed?: false, new_record?: false, item_metadata: metadata_fields, errors: item_errors) }

      it "returns a hash with correct summary" do
        expected = { total_count: 3, valid_count: 0, new_count: 0, error_count: 3, changed_count: 0, unchanged_count: 0 }
        subject
        expect(counts).to include(expected)
      end

      it "returns a hash with errors" do
        expected = [
          { errors: ["Item validation error"], item: item },
          { errors: ["Item validation error"], item: item },
          { errors: ["Item validation error"], item: item }
        ]
        subject
        expect(errors).to eq(expected)
      end
    end
  end

  context "called with no items" do
    let(:items) { [] }

    it "returns a hash with summary" do
      expected = { total_count: 0, valid_count: 0, new_count: 0, error_count: 0, changed_count: 0, unchanged_count: 0 }
      subject
      expect(counts).to include(expected)
    end

    it "returns a hash with errors" do
      subject
      expect(errors).to eq([])
    end
  end
end
