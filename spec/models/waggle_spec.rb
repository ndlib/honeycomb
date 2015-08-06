RSpec.describe Waggle do
  describe "adapter" do
    subject { described_class.adapter }
    it "is the sunspot adapter" do
      expect(subject).to eq(described_class::Adapters::Sunspot)
    end
  end

  describe "setup" do
    subject { described_class.setup }

    it "calls setup on the adapter" do
      expect(described_class.adapter).to receive(:setup)
      subject
    end
  end

  context "indexing" do
    let(:instances) { [instance_double(Waggle::Item), instance_double(Waggle::Item)] }

    describe "index" do
      subject { described_class.index(instances) }

      it "calls index on the adapter" do
        expect(described_class.adapter).to receive(:index).with(instances)
        subject
      end
    end

    describe "index!" do
      subject { described_class.index!(instances) }

      it "call index! on the adapter" do
        expect(described_class.adapter).to receive(:index!).with(instances)
        subject
      end
    end
  end

  describe "commit" do
    subject { described_class.commit }

    it "call commit on the adapter" do
      expect(described_class.adapter).to receive(:commit)
      subject
    end
  end
end
