require 'rails_helper'

RSpec.describe CollectionJson do
  let(:collection) { instance_double(Collection, id: 2, title: 'title')}

  let(:options) { {} }
  subject { described_class.new(collection) }
  let(:result_hash) { subject.to_hash(options) }

  describe '#collection_data' do
    [:title, :id].each do | field |
      it "includes the field, #{field}, from the collection" do
        expect(collection).to receive(field).and_return(field)
        expect(subject.send(:collection_data)[field]).to eq(field)
      end
    end

    it "is the expected format" do
      expect(subject.send(:collection_data)).to eq({:id=>2, :title=>"title"})
    end
  end

  describe '#to_json' do
    it 'calls to_json on the result of to_hash' do
      expect(subject).to receive(:to_hash).with(options).and_return({test: 'json'})
      expect(subject.to_json).to eq("{\"test\":\"json\"}")
    end
  end

  context "no options" do
    it "is the #collection_data" do
      expect(subject).to receive(:collection_data).and_return({collection_data: 'collection_data'})
      expect(result_hash).to eq({collection_data: 'collection_data'})
    end
  end

end
