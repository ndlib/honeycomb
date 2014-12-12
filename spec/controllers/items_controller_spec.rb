require "rails_helper"

RSpec.describe ItemsController, :type => :controller do
  let(:item) { instance_double(Item, id: 1, title: 'title', collection: collection) }
  let(:items) { [item] }
  let(:collection) { instance_double(Collection, id: 1, title: 'title') }
  let(:relation) { Item.all }

  before(:each) do
    allow(collection).to receive(:items).and_return(items)
    allow(Collection).to receive(:find).and_return(collection)

    @user = User.new(username: 'jhartzle')
    @user.save!

    sign_in @user
  end

  describe "GET #index" do

    it "returns a 200" do
      expect(collection).to receive(:items).and_return(Item.all)
      get :index, collection_id: collection.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template("index")
    end

    it "gets all the items to pass to the view" do
      expect(collection).to receive(:items).and_return(Item.all)
      get :index, collection_id: collection.id
    end
  end


  describe "GET #new" do

    it "returns a 200" do
      allow(collection.items).to receive(:build).and_return(item)

      get :new, collection_id: collection.id
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template("new")
    end

    it "creates a new item " do
      expect(collection.items).to receive(:build).and_return(item)
      get :new, collection_id: collection.id
    end
  end


  describe "POST #create" do
    let(:valid_params) { {collection_id: collection.id, item: { title: 'title' }} }

    before(:each) do
      expect(collection.items).to receive(:build).and_return(item)
    end

    it "redirects on success" do
      expect(SaveItem).to receive(:call).and_return(true)

      post :create, valid_params
      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "renders new on failure" do
      expect(SaveItem).to receive(:call).and_return(false)

      post :create, valid_params

      expect(response).to render_template("new")
    end

    it "creates a blank new item" do
      expect(SaveItem).to receive(:call).and_return(true)

      post :create, valid_params
    end
  end

  describe "GET #show" do

    it "returns a 200" do
      get :show, id: 1, collection_id: collection.id
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template("show")
    end

    it "finds an existing item " do
      expect(collection.items).to receive(:find).with("1").and_return(item)
      get :show, id: 1, collection_id: collection.id
    end
  end


  describe "GET #edit" do

    it "returns a 200" do
      get :edit, id: 1, collection_id: collection.id
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template("edit")
    end

    it "finds an existing item " do
      expect(collection.items).to receive(:find).with("1").and_return(item)
      get :edit, id: 1, collection_id: collection.id
    end
  end


  describe "PUT #update" do
    let(:valid_params) { {id: 1, collection_id: collection.id, item: { title: 'title' }} }

    before(:each) do
      expect(collection.items).to receive(:find).and_return(item)
    end

    it "redirects on success" do
      expect(SaveItem).to receive(:call).and_return(true)

      put :update, valid_params
      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "renders new on failure" do
      expect(SaveItem).to receive(:call).and_return(false)

      put :update, valid_params

      expect(response).to render_template("edit")
    end

    it "creates a blank new item" do
      expect(SaveItem).to receive(:call).and_return(true)

      put :update, valid_params
    end
  end


  describe "DELETE #destroy" do

    before(:each) do
      expect(collection.items).to receive(:find).and_return(item)
    end

    it "calls destroy on the item on success, redirects, and flashes " do
      expect(item).to receive(:destroy).and_return(true)

      delete :destroy, id: 1, collection_id: collection.id
      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "calls destroy on the item on failure, redirects, and flashes " do
      expect(item).to receive(:destroy).and_return(false)

      delete :destroy, id: 1, collection_id: collection.id
      expect(response).to be_redirect
      expect(flash[:error]).to_not be_nil
    end

  end
end
