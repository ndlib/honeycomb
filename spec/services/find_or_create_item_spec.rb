require "rails_helper"

describe FindOrCreateItem do
  let(:subject) { described_class.new(props: item_hash) }
  let(:item_hash) { { collection_id: 1, name: "item", unique_id: "item", user_defined_id: "item" } }
  let(:item_errors) { instance_double(ActiveModel::Errors, full_messages: []) }
  let(:metadata_fields) { instance_double(Metadata::Fields, errors: item_errors, valid?: true) }
  let(:item) do
    instance_double(Item, save: true,
                          new_record?: true,
                          changed?: false,
                          assign_attributes: true,
                          "unique_id=" => true,
                          item_metadata: metadata_fields,
                          valid?: true,
                          **item_hash)
  end

  before(:each) do
    allow(Metadata::Setter).to receive(:call).and_return(true)
    allow(Item).to receive(:find_or_initialize_by).and_return(item)
  end

  context "using method" do
    it "uses both collection id and user defined id to find the item" do
      expect(Item).to receive(:find_or_initialize_by).with(collection_id: 1, user_defined_id: "item").and_return(item)
      subject.using(prop_keys: [:collection_id, :user_defined_id])
    end

    it "uses empty hash to find the item when no prop_keys are given" do
      expect(Item).to receive(:find_or_initialize_by).with({}).and_return(item)
      subject.using(prop_keys: [])
    end
  end

  context "new item" do
    before(:each) do
      allow(item).to receive(:new_record?).and_return(true)
      allow(item).to receive(:changed?).and_return(false)
    end

    it "new_record? returns true" do
      subject.find_or_create_by(criteria: {})
      expect(subject.new_record?).to eq(true)
    end

    it "changed? returns false" do
      subject.find_or_create_by(criteria: {})
      expect(subject.changed?).to eq(false)
    end

    it "changed? returns false even when item.changed? returns true" do
      allow(item).to receive(:changed?).and_return(true)
      subject.find_or_create_by(criteria: {})
      expect(subject.changed?).to eq(false)
    end
  end

  context "existing item" do
    before(:each) do
      allow(item).to receive(:new_record?).and_return(false)
    end

    it "new_record? returns false" do
      subject.find_or_create_by(criteria: {})
      expect(subject.new_record?).to eq(false)
    end

    it "changed? returns true if the item was changed" do
      allow(item).to receive(:changed?).and_return(true)
      subject.find_or_create_by(criteria: {})
      expect(subject.changed?).to eq(true)
    end

    it "changed? returns false if the item was not changed" do
      allow(item).to receive(:changed?).and_return(false)
      subject.find_or_create_by(criteria: {})
      expect(subject.changed?).to eq(false)
    end
  end

  it "assigns the attributes given to the item using the Metadata::Setter" do
    expect(item).to receive(:assign_attributes).with(item_hash)
    subject.find_or_create_by(criteria: {})
  end

  it "generates a unique id" do
    expect(CreateUniqueId).to receive(:call).with(item)
    subject.find_or_create_by(criteria: {})
  end

  it "calls validation on the item" do
    expect(item).to receive(:valid?)
    subject.find_or_create_by(criteria: {})
  end

  context "when saving the created item" do
    it "uses SaveItem to save the item" do
      expect(SaveItem).to receive(:call).with(item, {}, index: true)
      subject.find_or_create_by(criteria: {})
      subject.save
    end

    it "only saves the item if it's valid" do
      allow(item).to receive(:valid?).and_return(false)
      expect(SaveItem).not_to receive(:call)
      subject.find_or_create_by(criteria: {})
      subject.save
    end

    it "returns false if SaveItem fails" do
      allow(SaveItem).to receive(:call).and_return(false)
      subject.find_or_create_by(criteria: {})
      expect(subject.save).to eq(false)
    end

    it "true if SaveItem succeeds" do
      allow(SaveItem).to receive(:call).and_return(item)
      subject.find_or_create_by(criteria: {})
      expect(subject.save).to eq(true)
    end
  end
end
