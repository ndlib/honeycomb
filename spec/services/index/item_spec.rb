RSpec.describe Index::Item do
  let(:item) { instance_double(Item) }

  describe "index!" do
    let(:waggle_item) { instance_double(Waggle::Item) }
    subject { described_class.index!(item) }
    before do
      allow(described_class).to receive(:item_to_waggle_item).and_return(waggle_item)
      allow(described_class).to receive(:get_configuration).and_return(double)
    end

    it "calls Waggle.index!" do
      expect(Waggle).to receive(:index!).with(waggle_item).and_return("index!")
      expect(subject).to eq("index!")
    end

    it "rescues from and notifies about errors" do
      expect(Waggle).to receive(:index!).and_raise(Errno::ECONNREFUSED)
      expect(NotifyError).to receive(:call).with(
        exception: kind_of(Errno::ECONNREFUSED),
        parameters: { item: item },
        component: described_class.to_s,
        action: "index!"
      )
      expect(subject).to be_nil
    end
  end

  describe "remove!" do
    let(:waggle_item) { instance_double(Waggle::Item) }
    subject { described_class.remove!(item) }
    before do
      allow(described_class).to receive(:item_to_waggle_item).and_return(waggle_item)
    end

    it "calls Waggle.index!" do
      expect(Waggle).to receive(:remove!).with(waggle_item).and_return("remove!")
      expect(subject).to eq("remove!")
    end

    it "rescues from and notifies about errors" do
      expect(Waggle).to receive(:remove!).and_raise(Errno::ECONNREFUSED)
      expect(NotifyError).to receive(:call).with(
        exception: kind_of(Errno::ECONNREFUSED),
        parameters: { item: item },
        component: described_class.to_s,
        action: "remove!"
      )
      expect(subject).to be_nil
    end
  end

  describe "item_to_waggle_item" do
    subject { described_class.send(:item_to_waggle_item, item) }
    it "converts an item to a waggle item" do
      expect(Waggle::Item).to receive(:from_item).with(item).and_return("waggle item")
      expect(subject).to eq("waggle item")
    end
  end
end
