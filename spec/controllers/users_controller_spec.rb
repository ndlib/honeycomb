require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { instance_double(User, id: 100, username: 'username') }
  let(:admin_user) { double(User, id: 99, username: 'dwolfe2', admin?: true) }
  let(:users) { [user] }
  let(:relation) { User.all }

  before(:each) do
    allow(User).to receive(:find).and_return(user)

    sign_in_admin
  end

  describe 'GET #index' do
    it 'returns a 200' do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template('index')
    end
  end
  describe 'GET #new' do
    it 'returns a 200' do
      get :new, user_id: user.id
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template('new')
    end

    it 'creates a new user ' do
      get :new, user_id: user.id
    end
  end

  describe 'POST #create' do
  end

  describe 'DELETE #destroy' do
    before(:each) do
      expect(User).to receive(:find).and_return(user)
    end

    it 'calls destroy on the user on success, redirects, and flashes ' do
      expect(user).to receive(:destroy).and_return(true)

      delete :destroy, id: 100
      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it 'calls destroy on the user on failure, redirects, and flashes ' do
      expect(user).to receive(:destroy).and_return(false)

      delete :destroy, id: 100
      expect(response).to be_redirect
      expect(flash[:error]).to_not be_nil
    end
  end

  describe 'GET #edit' do
    it 'returns a 200' do
      get :edit, id: 100
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template('edit')
    end

    it 'finds an existing user ' do
      expect(User).to receive(:find).with('100').and_return(user)
      get :edit, id: 100
    end
  end
  describe 'GET #show' do
    it 'returns a 200' do
      get :show, id: 100
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template('show')
    end

    it 'finds an existing user ' do
      expect(User).to receive(:find).with('100').and_return(user)
      get :show, id: 100
    end
  end
  describe 'PUT #update' do
    before(:each) do
      expect(User).to receive(:find).with('100').and_return(user)
      expect(user).to receive(:save)
    end

    it 'redirects on save' do
      put :update, id: 100
      expect(response).to be_redirect
    end

    it 'finds an existing user ' do
      put :update, id: 100
    end
  end

  describe 'PUT #revoke_admin' do
    it 'sets the admin to false and redirects to user path' do
      expect(User).to receive(:find).with('100').and_return(user)
      expect(RevokeAdminOnUser).to receive(:call).with(user)
      put :revoke_admin, user_id: user.id
      expect(flash[:notice]).to_not be_nil
      expect(response).to be_redirect
    end
  end

  describe 'PUT #set_admin' do
    it 'sets the admin to true and redirects to user path' do
      expect(User).to receive(:find).with('100').and_return(user)
      expect(SetAdminOnUser).to receive(:call).with(user)
      put :set_admin, user_id: user.id
      expect(flash[:notice]).to_not be_nil
      expect(response).to be_redirect
    end
  end
end
