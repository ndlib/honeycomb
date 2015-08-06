RSpec.describe Waggle::Adapters::Sunspot do
  describe "setup" do
    before do
      described_class.instance_variable_set(:@setup, nil)
    end

    it "registers the sunspot adapters once" do
      expect(described_class).to receive(:register_sunspot_adapters).once
      described_class.setup
      described_class.setup
    end

    it "sets up the indexers once" do
      expect(described_class).to receive(:setup_indexers).once
      described_class.setup
      described_class.setup
    end
  end

  describe "setup_indexers" do
    subject { described_class.setup_indexers }

    it "sets up the item indexer" do
      expect(described_class::Index::Item).to receive(:setup)
      subject
    end
  end

  describe "register_sunspot_adapters" do
    subject { described_class.register_sunspot_adapters }

    it "registers the adapters with sunspot" do
      expect(::Sunspot::Adapters::InstanceAdapter).to receive(:register).
        with(described_class::Adapters::InstanceAdapter, Waggle::Item)
      expect(::Sunspot::Adapters::DataAccessor).to receive(:register).
        with(described_class::Adapters::ItemDataAccessor, Waggle::Item)
      subject
    end
  end

  context "indexing" do
    let(:instances) { [instance_double(Waggle::Item), instance_double(Waggle::Item)] }

    describe "index" do
      subject { described_class.index(instances) }

      it "calls index on Sunspot" do
        expect(::Sunspot).to receive(:index).with(instances)
        subject
      end
    end

    describe "index!" do
      subject { described_class.index!(instances) }

      it "calls index! on Sunspot" do
        expect(::Sunspot).to receive(:index!).with(instances)
        subject
      end
    end
  end

  describe "commit" do
    subject { described_class.commit }

    it "calls commit on Sunspot" do
      expect(::Sunspot).to receive(:commit)
      subject
    end
  end
end
