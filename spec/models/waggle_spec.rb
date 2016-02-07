RSpec.describe Waggle do
  describe "adapter" do
    subject { described_class.adapter }
    it "is the Solr adapter" do
      expect(subject).to eq(described_class::Adapters::Solr)
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

    describe "remove" do
      subject { described_class.remove(instances) }

      it "calls remove on the adapter" do
        expect(described_class.adapter).to receive(:remove).with(instances)
        subject
      end
    end

    describe "remove!" do
      subject { described_class.remove!(instances) }

      it "call remove! on the adapter" do
        expect(described_class.adapter).to receive(:remove!).with(instances)
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

  describe "search" do
    let(:search_arguments) do
      {
        q: "q",
        facets: nil,
        sort: nil,
        rows: nil,
        start: nil,
        collection: instance_double(Collection)
      }
    end

    let(:passed_arguments) do
      {
        q: "q",
        facets: nil,
        sort: nil,
        rows: nil,
        start: nil,
      }
    end

    before(:each) do
      allow_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(double)
    end

    subject { described_class.search(**search_arguments) }

    it "calls Waggle::Search::Query.new" do
      query = instance_double(Waggle::Search::Query, result: "result")
      expect(Waggle::Search::Query).to receive(:new).with(**passed_arguments).and_return(query)
      expect(subject).to eq(query.result)
    end

    it "sets the configuration from the collection" do
      expect(Waggle).to receive(:set_configuration)
      subject
    end
  end
end
