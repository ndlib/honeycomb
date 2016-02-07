require "rails_helper"
require "support/item_meta_helpers"

RSpec.configure do |c|
  c.include ItemMetaHelpers, helpers: :item_meta_helpers
end

RSpec.describe RewriteItemMetadata, helpers: :item_meta_helpers do
  let(:item) { {} }
  let(:errors) { [] }
  let(:configuration) { instance_double(Metadata::Configuration, field_names: ["name", "alternate_name", "date_created"], field?: true, label?: true) }
  let(:field) { double(name: "name", multiple: false, type: :string) }
  let(:date_field) { double(name: "date_created", multiple: false, type: :date) }
  let(:multiple_field) { double(name: "alternate_name", multiple: true, type: :string) }
  let(:subject) { described_class.call(item_hash: item, errors: errors, configuration: configuration) }

  before(:each) do
    allow(configuration).to receive(:field?).and_return(false)
    allow(configuration).to receive(:label?).and_return(false)
  end

  it "rewrites all fields from labels to field names" do
    allow(configuration).to receive(:label).with("Name").and_return(field)
    allow(configuration).to receive(:field?).with("name").and_return(true)
    allow(configuration).to receive(:label?).with("Name").and_return(true)

    item["Name"] = "the name"
    expect(subject).to eq("name" => "the name", "alternate_name" => nil, "date_created" => nil)
  end

  it "rewrites multiples to an array" do
    allow(configuration).to receive(:label).with("Alternate Name").and_return(multiple_field)
    allow(configuration).to receive(:field?).with("alternate_name").and_return(true)
    allow(configuration).to receive(:label?).with("Alternate Name").and_return(true)

    item["Alternate Name"] = "name1||name2"
    expect(subject).to eq("name" => nil, "alternate_name" => ["name1", "name2"], "date_created" => nil)
  end

  context "rewrites dates" do
    it "handles bc date" do
      allow(configuration).to receive(:label).with("Date Created").and_return(date_field)
      allow(configuration).to receive(:field?).with("date_created").and_return(true)
      allow(configuration).to receive(:label?).with("Date Created").and_return(true)

      item["Date Created"] = "-2001/01/01"
      expect(subject).to eq(
        "name" => nil,
        "alternate_name" => nil,
        "date_created" => { "year" => "2001", "month" => "1", "day" => "1", "bc" => true, "display_text" => nil }
      )
    end

    it "can handle string literal indicator" do
      allow(configuration).to receive(:label).with("Date Created").and_return(date_field)
      allow(configuration).to receive(:field?).with("date_created").and_return(true)
      allow(configuration).to receive(:label?).with("Date Created").and_return(true)

      item["Date Created"] = "'-2001/01/01"
      expect(subject).to eq(
        "name" => nil,
        "alternate_name" => nil,
        "date_created" => { "year" => "2001", "month" => "1", "day" => "1", "bc" => true, "display_text" => nil }
      )
    end
  end

  it "adds to the given errors array when a label is not found" do
    allow(Item).to receive(:method_defined?).and_return false
    subject
    expected = item.keys.map { |attribute| "Unknown attribute #{attribute}" }
    expect(errors).to eq(expected)
  end
end
