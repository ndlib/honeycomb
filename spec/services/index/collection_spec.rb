RSpec.describe Index::Collection do
  let(:item) { instance_double(Item) }
  let(:waggle_item) { instance_double(Waggle::Item) }
  let(:config) { instance_double(CollectionConfiguration) }
  let(:collection) { instance_double(Collection, items: [item, item], collection_configuration: config) }

  describe "index!" do
    subject { described_class.index!(collection: collection) }
    before do
      allow(Waggle::Item).to receive(:from_item).and_return(waggle_item)
      allow_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(config)
    end

    it "calls Waggle.index! with wagglified items for all items in the collection" do
      expect(Waggle).to receive(:index!).with(waggle_item).and_return("index!").twice
      subject
    end

    it "doesn't call waggle if there are no items" do
      allow(collection).to receive(:items).and_return([])
      expect(Waggle).not_to receive(:index!)
      subject
    end

    it "uses the configuration of the collection for all items" do
      allow(Waggle).to receive(:index!).and_return("index!")
      expect(Waggle).to receive(:set_configuration).with(config).once
      subject
    end

    it "rescues from and notifies about errors" do
      expect(Waggle).to receive(:index!).and_raise(Errno::ECONNREFUSED)
      expect(NotifyError).to receive(:call).with(
        exception: kind_of(Errno::ECONNREFUSED),
        parameters: { collection: collection },
        component: described_class.to_s,
        action: "index!"
      )
      expect(subject).to be_nil
    end
  end

  describe "remove!" do
    subject { described_class.remove!(collection: collection) }
    before do
      allow(Waggle::Item).to receive(:from_item).and_return(waggle_item)
      allow_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(config)
    end

    it "calls Waggle.remove! with wagglified items for all items in the collection" do
      expect(Waggle).to receive(:remove!).with(waggle_item).and_return("remove!").twice
      subject
    end

    it "doesn't call waggle if there are no items" do
      allow(collection).to receive(:items).and_return([])
      expect(Waggle).not_to receive(:remove!)
      subject
    end

    it "uses the configuration of the collection for all items" do
      allow(Waggle).to receive(:remove!).and_return("remove!")
      expect(Waggle).to receive(:set_configuration).with(config).once
      subject
    end

    it "rescues from and notifies about errors" do
      expect(Waggle).to receive(:remove!).and_raise(Errno::ECONNREFUSED)
      expect(NotifyError).to receive(:call).with(
        exception: kind_of(Errno::ECONNREFUSED),
        parameters: { collection: collection },
        component: described_class.to_s,
        action: "remove!"
      )
      expect(subject).to be_nil
    end
  end
end
