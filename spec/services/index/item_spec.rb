RSpec.describe Index::Item do
  let(:item) { instance_double(Item) }

  describe "index!" do
    let(:waggle_item) { instance_double(Waggle::Item) }
    subject { described_class.index!(item) }
    before do
      allow(described_class).to receive(:item_to_waggle_item).and_return(waggle_item)
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

  describe "api_data" do
    let(:decorator) { instance_double(V1::ItemJSONDecorator, to_hash: { test: "test" }) }
    subject { described_class.api_data(item) }

    it "converts an item to a hash" do
      expect(V1::ItemJSONDecorator).to receive(:new).with(item).and_return(decorator)
      expect(subject).to eq(decorator.to_hash)
    end
  end

  describe "item_to_waggle_item" do
    subject { described_class.item_to_waggle_item(item) }
    it "converts an item to a waggle item" do
      expect(described_class).to receive(:api_data).with(item).and_return(test: "test")
      expect(Waggle::Item).to receive(:new).with(test: "test").and_return("waggle item")
      expect(subject).to eq("waggle item")
    end
  end
end
