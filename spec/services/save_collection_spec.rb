require 'rails_helper'

RSpec.describe SaveCollection, type: :model do
  subject { described_class.call(collection, params) }
  let(:collection) { double(Collection, id: 'id', 'attributes=' => true, save: true) }
  let(:params) { { title: 'title' } }

  before(:each) do
    allow(CreateUniqueId).to receive(:call).and_return(true)
    allow(EnsureCollectionHasExhibit).to receive(:call).and_return(true)
  end

  it 'returns when the collection save is successful' do
    expect(collection).to receive(:save).and_return(true)
    expect(subject).to be true
  end

  it 'returns when the collection save is not successful' do
    expect(collection).to receive(:save).and_return(false)
    expect(subject).to be false
  end

  it 'sets the attributes of the collection to be the passed in attributes ' do
    expect(collection).to receive(:attributes=).with(params)
    subject
  end

  describe 'unique_id' do
    it 'uses the class to generate the id' do
      expect(CreateUniqueId).to receive(:call).with(collection)
      subject
    end

    it 'does not call create unique_id if the collection does not save' do
      allow(collection).to receive(:save).and_return(false)
      expect(CreateUniqueId).to_not receive(:call).with(collection)
      subject
    end
  end

  describe 'exhibit' do
    it 'calls EnsureCollectionHasExhibit' do
      expect(EnsureCollectionHasExhibit).to receive(:call).with(collection)
      subject
    end
  end
end
