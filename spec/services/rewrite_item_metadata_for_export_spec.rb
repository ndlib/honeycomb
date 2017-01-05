require "rails_helper"
require "support/item_meta_helpers"

RSpec.configure do |c|
  c.include ItemMetaHelpers, helpers: :item_meta_helpers
end

RSpec.describe RewriteItemMetadataForExport, helpers: :item_meta_helpers do
  let(:item) { {} }
  let(:configuration) do
    instance_double(
      Metadata::Configuration,
      field_labels: ["Name", "Alternate Name", "Date Created"],
      field_names: ["name", "alternate_name", "date_created"]
    )
  end
  let(:field) { double(name: "name", label: "Name", multiple: false, type: :string) }
  let(:date_field) { double(name: "date_created", label: "Date Created", multiple: false, type: :date) }
  let(:multiple_field) { double(name: "alternate_name", label: "Alternate Name", multiple: true, type: :string) }
  let(:subject) { described_class.call(item_hash: item, configuration: configuration, user_defined_id: "user_defined_id", parent_user_defined_id: "parent_user_defined_id") }

  before(:each) do
    allow(configuration).to receive(:field?).and_return(false)
    allow(configuration).to receive(:label?).and_return(false)
  end

  it "adds the user defined id" do
    expect(subject).to include("Identifier" => "user_defined_id")
  end

  it "adds the parent's user defined id" do
    expect(subject).to include("Parent Identifier" => "parent_user_defined_id")
  end

  it "adds all fields, even when there is no metadata assigned" do
    expect(subject).to include("Name" => nil, "Alternate Name" => nil, "Date Created" => nil)
  end

  it "rewrites non-multiples as a single value" do
    allow(configuration).to receive(:field).with(:name).and_return(field)
    allow(configuration).to receive(:field?).with(:name).and_return(true)
    item[:name] = ["Name"]
    expect(subject).to include("Name" => "Name")
  end

  it "grabs the first value if its not a multiple" do
    allow(configuration).to receive(:field).with(:name).and_return(field)
    allow(configuration).to receive(:field?).with(:name).and_return(true)
    item[:name] = ["Name1", "Name2"]
    expect(subject).to include("Name" => "Name1")
  end

  it "rewrites all fields from labels to field names" do
    allow(configuration).to receive(:field).with(:name).and_return(field)
    allow(configuration).to receive(:field?).with(:name).and_return(true)

    item[:name] = ["the Name"]

    expect(subject).to include("Name" => "the Name")
  end

  it "rewrites multiples to an array" do
    allow(configuration).to receive(:field).with(:alternate_name).and_return(multiple_field)
    allow(configuration).to receive(:field?).with(:alternate_name).and_return(true)

    item[:alternate_name] = ["name1", "name2"]
    expect(subject).to include("Alternate Name" => "name1||name2")
  end

  context "rewrites dates" do
    it "handles bc date" do
      allow(configuration).to receive(:field).with(:date_created).and_return(date_field)
      allow(configuration).to receive(:field?).with(:date_created).and_return(true)

      item[:date_created] = [{ "year" => "2001", "month" => "1", "day" => "1", "bc" => true, "display_text" => nil }]
      expect(subject).to include("Date Created" => "-2001/01/01")
    end
  end
end
