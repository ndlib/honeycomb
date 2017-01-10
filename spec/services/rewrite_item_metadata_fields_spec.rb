require "rails_helper"
require "support/item_meta_helpers"

RSpec.configure do |c|
  c.include ItemMetaHelpers, helpers: :item_meta_helpers
end

RSpec.describe RewriteItemMetadata, helpers: :item_meta_helpers do
  let(:item_hash) { {} }
  let(:errors) { [] }
  let(:configuration) { instance_double(Metadata::Configuration, field_names: ["name", "alternate_name", "date_created"], field?: true, label?: true) }
  let(:field) { double(name: "name", multiple: false, type: :string) }
  let(:date_field) { double(name: "date_created", multiple: false, type: :date) }
  let(:multiple_field) { double(name: "alternate_name", multiple: true, type: :string) }
  let(:subject) { described_class.call(item_hash: item_hash, errors: errors, configuration: configuration) }

  before(:each) do
    allow(configuration).to receive(:field?).and_return(false)
    allow(configuration).to receive(:label?).and_return(false)
  end

  it "rewrites the hash to match item property structure" do
    item_hash["Identifier"] = "identifier"
    expect(subject).to include(:user_defined_id, :metadata)
  end

  it "rewrites all fields from labels to field names" do
    allow(configuration).to receive(:label).with("Name").and_return(field)
    allow(configuration).to receive(:field?).with("name").and_return(true)
    allow(configuration).to receive(:label?).with("Name").and_return(true)

    item_hash["Name"] = "the name"
    expect(subject[:metadata]).to eq("name" => "the name", "alternate_name" => nil, "date_created" => nil)
  end

  it "rewrites multiples to an array" do
    allow(configuration).to receive(:label).with("Alternate Name").and_return(multiple_field)
    allow(configuration).to receive(:field?).with("alternate_name").and_return(true)
    allow(configuration).to receive(:label?).with("Alternate Name").and_return(true)

    item_hash["Alternate Name"] = "name1||name2"
    expect(subject[:metadata]).to eq("name" => nil, "alternate_name" => ["name1", "name2"], "date_created" => nil)
  end

  context "rewrites dates" do
    it "handles bc date" do
      allow(configuration).to receive(:label).with("Date Created").and_return(date_field)
      allow(configuration).to receive(:field?).with("date_created").and_return(true)
      allow(configuration).to receive(:label?).with("Date Created").and_return(true)

      item_hash["Date Created"] = "-2001/01/01"
      expect(subject[:metadata]).to eq(
        "name" => nil,
        "alternate_name" => nil,
        "date_created" => { "year" => "2001", "month" => "1", "day" => "1", "bc" => true, "display_text" => nil }
      )
    end

    it "can handle string literal indicator" do
      allow(configuration).to receive(:label).with("Date Created").and_return(date_field)
      allow(configuration).to receive(:field?).with("date_created").and_return(true)
      allow(configuration).to receive(:label?).with("Date Created").and_return(true)

      item_hash["Date Created"] = "'-2001/01/01"
      expect(subject[:metadata]).to eq(
        "name" => nil,
        "alternate_name" => nil,
        "date_created" => { "year" => "2001", "month" => "1", "day" => "1", "bc" => true, "display_text" => nil }
      )
    end
  end

  it "adds to the given errors array when a label is not found" do
    allow(Item).to receive(:method_defined?).and_return false
    subject
    expected = item_hash.keys.map { |attribute| "Unknown attribute #{attribute}" }
    expect(errors).to eq(expected)
  end

  context "when it has a parent identifier column with a value" do
    let(:parent_item) { instance_double(Item, id: 1) }
    let(:parent_item_relation) { instance_double(ActiveRecord::Relation, take: parent_item) }

    before(:each) do
      item_hash["Parent Identifier"] = "parent id"
    end

    it "finds the parent by user defined id" do
      expect(Item).to receive(:where).with(user_defined_id: "parent id").and_return(parent_item_relation)
      subject
    end

    it "adds a parent_id field to the hash using the id of the found parent" do
      allow(Item).to receive(:where).with(user_defined_id: "parent id").and_return(parent_item_relation)
      expect(subject[:parent_id]).to eq(1)
    end

    it "adds an error if the parent item does not exist" do
      subject
      expected = item_hash.keys.map { "Unable to find parent item 'parent id'" }
      expect(errors).to eq(expected)
    end
  end

  context "when it has a parent identifier column with no value" do
    before(:each) do
      item_hash["Parent Identifier"] = nil
    end

    it "does not query for the parent" do
      expect(Item).not_to receive(:where).with(user_defined_id: "parent id")
      subject
    end

    it "adds a parent_id to the hash with a value of nil to disassociate a child item from its current parent if the value is nil" do
      item_hash["Parent Identifier"] = nil
      expect(subject[:parent_id]).to eq(nil)
    end
  end

  context "when it does not have a parent identifier column" do
    before(:each) do
      item_hash.delete("Parent Identifier")
    end

    it "does not add a parent_id field to the hash, so that it's associations do not change" do
      expect(subject.key?(:parent_id)).to eq(false)
    end
  end
end
