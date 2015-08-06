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
end
