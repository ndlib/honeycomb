require 'rails'

RSpec.describe PersonAPISearch do
  let(:query) { 'test' }
  subject { described_class.new(query) }

  describe '#query' do
    it 'is the query' do
      expect(subject.query).to eq('test')
    end
  end

  describe '#query_search_string' do
    describe 'blank query' do
      let(:query) { '' }

      it 'returns nil' do
        expect(subject.send(:query_search_string)).to be_nil
      end
    end

    describe 'nil query' do
      let(:query) { nil }

      it 'returns nil' do
        expect(subject.send(:query_search_string)).to be_nil
      end
    end

    describe 'special characters' do
      let(:query) { '<test>' }
      it 'encodes the query string and adds a wildcard' do
        expect(subject.send(:query_search_string)).to eq("%3Ctest%3E*")
      end
    end
  end

  describe '#results' do

    it 'calls HesburghAPI::PersonSearch with a formatted term' do
      expect(HesburghAPI::PersonSearch).to receive(:search).with('test*').and_return([])
      expect(subject.results).to eq([])
    end

    describe 'no results' do
      before do
        allow(HesburghAPI::PersonSearch).to receive(:search).and_return(nil)
      end

      it 'returns an empty array' do
        expect(subject.results).to eq([])
      end
    end

    describe 'blank search' do
      let(:query) { nil }

      it 'returns an empty array' do
        expect(subject.results).to eq([])
      end
    end

    describe 'multiple results' do
      let(:person_search_results) {
        [
          {
              "first_name" => "Robert",
              "full_name" => "Robert Franklin",
              "last_name" => "Franklin",
              "uid" => "fake1"
          },
          {
              "first_name" => "Robert",
              "full_name" => "Robert Austin",
              "last_name" => "Austin",
              "uid" => "fake2"
          }
        ]
      }

      before do
        allow(HesburghAPI::PersonSearch).to receive(:search).and_return(person_search_results)
      end

      it 'returns a formatted list' do
        expect(subject.results).to be_a_kind_of(Array)
        expect(subject.results.count).to eq(2)
        expect(subject.results.first).to eq({id: "fake1", label: "Robert Franklin", value: "Robert Franklin"})
      end
    end
  end

  describe 'self' do
    subject { described_class }

    describe '#call' do
      let(:test_results) { [{id: "fake1", label: "Robert Franklin", value: "Robert Franklin"}] }
      it 'returns the results from a new instance' do
        expect(subject).to receive(:new).with('test').and_call_original
        expect_any_instance_of(described_class).to receive(:results).and_return(test_results)
        expect(subject.call('test')).to eq(test_results)
      end
    end
  end
end
