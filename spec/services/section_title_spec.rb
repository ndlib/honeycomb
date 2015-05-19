require "rails_helper"

describe SectionTitle do
  subject { described_class.new(section) }
  let(:section) { double(Section, title: "section_title", item: item) }
  let(:item) { double(Item, name: "item_name") }

  describe "#title" do
    it "chooses the item name if the section title is nil" do
      expect(section).to receive(:title).and_return(nil)
      expect(subject.title).to eq("item_name")
    end

    it "chooses the section title even if there is an item title" do
      expect(subject.title).to eq("section_title")
    end

    it "sends empty string if both are nil" do
      expect(section).to receive(:title).and_return(nil)
      expect(item).to receive(:name).and_return(nil)

      expect(subject.title).to eq("")
    end
  end

  describe "#call" do
    it "calls title" do
      expect_any_instance_of(SectionTitle).to receive(:title)
      described_class.call(section)
    end
  end
end
