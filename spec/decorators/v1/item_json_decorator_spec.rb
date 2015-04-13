require 'rails_helper'

RSpec.describe V1::ItemJSONDecorator do
  subject { described_class.new(item) }

  let(:item) { double(Item) }
  let(:json) { double }

  describe 'generic fields' do
    [:id, :title, :collection, :unique_id, :description, :updated_at].each do |field|
      it "responds to #{field}" do
        expect(subject).to respond_to(field)
      end
    end
  end

  describe '#at_id' do
    let(:item) { double(Item, unique_id: 'adsf') }

    it 'returns the path to the id' do
      expect(subject.at_id).to eq('http://test.host/v1/items/adsf')
    end
  end

  describe '#collection_url' do
    let(:item) { double(Item, collection: collection) }
    let(:collection) { double(Collection, unique_id: 'colasdf') }

    it 'returns the path to the items' do
      expect(subject.collection_url).to eq('http://test.host/v1/collections/colasdf')
    end
  end

  describe '#description' do
    let(:item) { double(Item, description: 'description') }

    it 'converts null to empty string' do
      allow(item).to receive(:description).and_return(nil)
      expect(subject.description).to eq('')
    end

    it 'uses the item description' do
      expect(item).to receive(:description).and_return('description')
      expect(subject.description).to eq('description')
    end
  end

  describe '#transcription' do
    let(:item) { double(Item, transcription: 'transcription') }

    it 'converts null to empty string' do
      allow(item).to receive(:transcription).and_return(nil)
      expect(subject.transcription).to eq('')
    end

    it 'uses the item transcription' do
      expect(item).to receive(:transcription).and_return('transcription')
      expect(subject.transcription).to eq('transcription')
    end
  end

  describe '#slug' do
    let(:item) { double(Item, title: 'title') }

    it 'Calls the slug generator' do
      expect(CreateURLSlug).to receive(:call).with(item.title).and_return('slug')
      expect(subject.slug).to eq('slug')
    end
  end

  describe '#image' do
    let(:item) { double(Item, honeypot_image: honeypot_image) }
    let(:honeypot_image) { double(HoneypotImage, json_response: 'json_response') }

    it 'gets the honeypot_image json_response' do
      expect(honeypot_image).to receive(:json_response).and_return('json_response')
      expect(subject.image).to eq('json_response')
    end
  end

  describe '#display' do
    let(:item) { double(Item) }

    it 'calls the partial for the display' do
      expect(json).to receive(:partial!).with('/v1/items/item', item_object: item)
      subject.display(json)
    end

    it 'returns nil if the item is nil ' do
      expect(described_class.new(nil).display(json)).to be_nil
    end
  end

  describe '#metadata' do
    let(:item) { double(Item, title: 'title', description: 'desc', manuscript_url: 'url', transcription: 'trans') }

    it 'creates a metadata hash of all metadata' do
      results = [{ label: 'Title', value: 'title' }, { label: 'Description', value: 'desc' }, { label: 'Manuscript', value: 'url' }, { label: 'Transcript', value: 'trans' }]

      expect(subject.metadata).to eq(results)
    end
  end
end
