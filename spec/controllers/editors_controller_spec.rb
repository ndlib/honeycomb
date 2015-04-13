require 'rails_helper'

RSpec.describe EditorsController, type: :controller do
  let(:collection) { instance_double(Collection, id: 1, collection_users: []) }
  let(:user) { instance_double(User, id: 100, username: 'username', name: 'name') }
  let(:collection_user) { double(CollectionUser, id: 1) }

  before(:each) do
    sign_in_admin
    allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
  end

  describe 'index' do
    it 'checks the editor permissions' do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      get :index, collection_id: 1
    end

    it 'uses collection query to get the colletion' do
      expect_any_instance_of(CollectionQuery).to receive(:find).with('1').and_return(collection)
      get :index, collection_id: 1
    end

    it 'is a success' do
      get :index, collection_id: 1
      expect(response).to be_success
    end
  end

  describe '#create' do
    it 'maps a user to a collection' do
      expect(FindOrCreateUser).to receive(:call).with(user.username).and_return(user)
      expect(AssignUserToCollection).to receive(:call).with(collection, user).and_return(collection_user)
      expect_any_instance_of(CollectionUserDecorator).to receive(:editor_hash).and_return(test: :test)
      post :create, user: { username: user.username }, collection_id: 1
      expect(response).to be_success
    end

    it 'errors if the user is not found' do
      expect(FindOrCreateUser).to receive(:call).with(user.username).and_return(false)
      post :create, user: { username: user.username }, collection_id: 1
      expect(response).to be_error
    end

    it 'errors if it fails to assign the user to the collection' do
      expect(FindOrCreateUser).to receive(:call).with(user.username).and_return(user)
      expect(AssignUserToCollection).to receive(:call).with(collection, user).and_return(false)
      post :create, user: { username: user.username }, collection_id: 1
      expect(response).to be_error
    end
  end

  describe '#destroy' do
    before do
      allow(User).to receive(:find).with(user.id.to_s).and_return(user)
    end

    it 'removes a user mapping to a collection' do
      expect(RemoveUserFromCollection).to receive(:call).with(collection, user).and_return(true)
      delete :destroy, id: user.id, collection_id: 1
      expect(flash[:notice]).to be_present
      expect(response).to be_redirect
    end

    it 'flashes an error and redirects if there is an error' do
      expect(RemoveUserFromCollection).to receive(:call).with(collection, user).and_return(false)
      delete :destroy, id: user.id, collection_id: 1
      expect(flash[:error]).to be_present
      expect(response).to be_redirect
    end
  end

  describe 'user_search' do
    let(:query) { 'test' }
    let(:test_results) { [{ id: 'fake1', label: 'Robert Franklin', value: 'Robert Franklin' }] }

    describe 'stubbed search' do
      before do
        allow(PersonAPISearch).to receive(:call).and_return([])
      end

      it 'checks the editor permissions' do
        expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
        get :user_search, collection_id: 1, q: query
        expect(response).to be_success
      end
    end

    it 'renders the json results from PersonAPISearch' do
      expect(PersonAPISearch).to receive(:call).with(query).and_return(test_results)
      get :user_search, collection_id: 1, q: query
      expect(response).to be_success
      expect(response.body).to eq(test_results.to_json)
    end
  end
end
