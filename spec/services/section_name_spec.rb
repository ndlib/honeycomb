require "rails_helper"

describe SectionName do
  subject { described_class.new(section) }
  let(:section) { double(Section, name: "section_name", item: item) }
  let(:item) { instance_double(Item, name: "item_name") }

  describe "#name" do
    it "chooses the item name if the section name is nil" do
      expect(section).to receive(:name).and_return(nil)
      expect(subject.name).to eq("item_name")
    end

    it "chooses the section name even if there is an item name" do
      expect(subject.name).to eq("section_name")
    end

    it "sends empty string if both are nil" do
      expect(section).to receive(:name).and_return(nil)
      expect(item).to receive(:name).and_return(nil)

      expect(subject.name).to eq("")
    end
  end

  describe "#call" do
    it "calls name" do
      expect_any_instance_of(SectionName).to receive(:name)
      described_class.call(section)
    end
  end
end
