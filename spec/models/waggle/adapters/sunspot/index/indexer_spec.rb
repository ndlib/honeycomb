RSpec.describe Waggle::Adapters::Sunspot::Index::Indexer do
  let(:dummy_class) do
    Class.new do
      include Waggle::Adapters::Sunspot::Index::Indexer
      def self.index_class
        Waggle::Item
      end
    end
  end

  let(:index_class) { dummy_class.index_class }

  describe "reset!" do
    subject { dummy_class.reset! }

    it "resets an existing setup" do
      dummy_class.setup_index {}
      expect(Sunspot::Setup.for(index_class)).to be_kind_of(Sunspot::Setup)
      subject
      expect(Sunspot::Setup.for(index_class)).to be_nil
    end
  end

  describe "setup_index" do
    it "sets up Sunspot for index_class" do
      dummy_class.reset!
      expect(Sunspot::Setup.for(index_class)).to be_nil
      expect_any_instance_of(Sunspot::DSL::Fields).to receive(:text).
        with(:name, stored: true).and_call_original
      dummy_class.setup_index do
        text :name, stored: true
      end
      expect(Sunspot::Setup.for(index_class)).to be_kind_of(Sunspot::Setup)
    end
  end

  context "no index_class" do
    let(:dummy_class) do
      Class.new do
        include Waggle::Adapters::Sunspot::Index::Indexer
      end
    end

    describe "index_class" do
      subject { dummy_class.index_class }
      it "must be implemented" do
        expect { subject }.to raise_error("index_class not implemented")
      end
    end
  end
end
