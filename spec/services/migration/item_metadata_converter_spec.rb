require "rails_helper"

describe Migration::ItemMetadataConverter do
  let(:metadata) { {} }
  let(:item) { instance_double(Item, id: 1, metadata: metadata, save!: true, name: "name", description: "description") }

  describe "#call" do
    it "gets all the items" do
      expect(Item).to receive(:all).and_return([item])
      described_class.call
    end

    it "calls convert on the class with the item" do
      allow(Item).to receive(:all).and_return([item])
      expect_any_instance_of(described_class).to receive(:convert!)
      described_class.call
    end
  end

  describe "#convert! " do
    subject { described_class.new(item).convert! }

    before(:each) do
      allow(metadata).to receive(:[])
      allow(metadata).to receive(:[]=)
    end

    it "converts the name if the name is not set in metadata" do
      expect(item).to receive(:name).and_return("NAME!")
      expect(metadata).to receive(:[]).with("name")
      expect(metadata).to receive(:[]=).with("name", ["NAME!"])
      subject
    end

    it "does not convert the name if the name is not set in metadata" do
      metadata["name"] = "TAKEN!"
      expect(metadata).to_not receive(:[]=).with("name", ["NAME!"])
      subject
    end

    it "converts the description if the description is not set in metadata" do
      expect(item).to receive(:description).and_return("Description!")
      expect(metadata).to receive(:[]).with("description")
      expect(metadata).to receive(:[]=).with("description", ["Description!"])

      subject
    end

    it "does not convert the description if the name is not set" do
      metadata["description"] = "TAKEN!"
      expect(metadata).to_not receive(:[]=).with("description", ["Description!"])
      subject
    end
  end
end
