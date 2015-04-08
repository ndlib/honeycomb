require 'rails'

describe ShowcaseQuery do
  subject { described_class.new(relation) }
  let(:relation) { Showcase.all }

  describe '#relation' do
    it 'returns the relation' do
      expect(subject.relation).to eq(relation)
    end
  end

  describe 'all' do
    it 'returns all the showcases' do
      expect(subject.all).to eq(relation)
    end
  end

  describe 'find' do
    it 'finds the object' do
      expect(relation).to receive(:find).with(1)
      subject.find(1)
    end
  end

  describe 'build' do
    it 'builds a object off of the relation' do
      expect(relation).to receive(:build)
      subject.build
    end

    it 'accepts default arguments' do
      item = subject.build(exhibit_id: 1)
      expect(item.exhibit_id).to eq(1)
    end
  end

  describe 'published' do
    it 'gets the published items' do
      # expect(relation).to receive(:where).with(published: true)
      subject.published
    end
  end

  describe 'public_find' do
    it 'calls public_find!' do
      expect(relation).to receive(:find_by!).with(unique_id: 'asdf')
      subject.public_find('asdf')
    end

    it 'raises an error on not found' do
      expect { subject.public_find('asdf') }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
