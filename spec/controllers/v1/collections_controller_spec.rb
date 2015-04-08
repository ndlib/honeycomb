require 'rails_helper'

RSpec.describe V1::CollectionsController, type: :controller do
  let(:collection) { instance_double(Collection, id: 1) }
  let(:collections) { [collection] }

  before(:each) do
    allow_any_instance_of(CollectionQuery).to receive(:public_collections).and_return(collections)
    allow_any_instance_of(CollectionQuery).to receive(:public_find).and_return(collection)
  end

  describe '#index' do
    subject { get :index, format: :json }
    it 'calls CollectionQuery' do
      expect_any_instance_of(CollectionQuery).to receive(:public_collections).and_return(collections)

      subject
    end

    it 'is successful' do
      subject

      expect(response).to be_success
      expect(assigns(:collections)).to be_present
      expect(subject).to render_template('v1/collections/index')
    end
  end

  describe '#show' do
    subject { get :show, id: 'id', format: :json }
    it 'calls CollectionQuery' do
      expect_any_instance_of(CollectionQuery).to receive(:public_find).with('id').and_return(collection)

      subject
    end

    it 'is successful' do
      subject

      expect(response).to be_success
      expect(assigns(:collection)).to be_present
      expect(subject).to render_template('v1/collections/show')
    end
  end
end
