RSpec.describe Waggle::Search::Result do
  let(:adapter_result) { instance_double(Waggle::Adapters::Solr::Search::Result) }
  let(:query) { instance_double(Waggle::Search::Query, configuration: configuration) }
  let(:configuration) { instance_double(Metadata::Configuration, sorts: []) }
  let(:instance) { described_class.new(query: query) }

  subject { instance }

  before do
    allow(Waggle.adapter).to receive(:search_result).and_return(adapter_result)
    Waggle.set_configuration(configuration)
  end

  describe "instance" do
    it "initializes with the query" do
      expect(subject.query).to eq(query)
    end
  end

  describe "start" do
    it "is the query start" do
      expect(query).to receive(:start).and_return(30)
      expect(subject.start).to eq(30)
    end
  end

  describe "rows" do
    it "is the query rows" do
      expect(query).to receive(:rows).and_return(15)
      expect(subject.rows).to eq(15)
    end
  end

  describe "total" do
    it "is the result total" do
      expect(adapter_result).to receive(:total).and_return(100)
      expect(subject.total).to eq(100)
    end
  end

  describe "facets" do
    it "returns the adapter facets" do
      expect(adapter_result).to receive(:facets).and_return([:facets])
      expect(subject.facets).to eq([:facets])
    end
  end

  describe "sorts" do
    it "includes the relevancy sort and the configured sorts" do
      expect(subject.sorts.count).to eq(1)
      relevancy = subject.sorts.first
      expect(relevancy.name).to eq("Relevance")
      expect(relevancy.value).to eq("score")
      configuration.sorts.each_with_index do |sort_config, index|
        expect(subject.sorts[index + 1].name).to eq(sort_config.label)
        expect(subject.sorts[index + 1].value).to eq(sort_config.name)
      end
    end
  end

  describe "hits" do
    let(:adapter_hits) { ["hit 1", "hit 2"] }
    it "maps the adapter hits to Waggle::Search::Hit instances" do
      expect(adapter_result).to receive(:hits).and_return(adapter_hits)
      adapter_hits.each do |hit|
        expect(Waggle::Search::Hit).to receive(:new).with(hit).and_call_original
      end
      expect(subject.hits).to match([kind_of(Waggle::Search::Hit), kind_of(Waggle::Search::Hit)])
    end
  end
end
