require "rails_helper"

RSpec.describe ItemChildrenController, :type => :controller do
  let(:item) { double(Item, id: 2, title: 'Child') }
  let(:parent) { double(Item, id: 1, title: 'Parent', children: children) }
  let(:children) { [ item ] }
  let(:items) { [ parent ] }
  let(:collection) { double(Collection, id: 1, title: 'Collection', items: items) }

  before(:each) do
    allow(Collection).to receive(:find).with(collection.id.to_s).and_return(collection)
    allow(items).to receive(:find).with(parent.id.to_s).and_return(parent)
    allow(children).to receive(:build)

    @user = User.new(username: 'jhartzle')
    @user.save!

    sign_in @user
  end

  describe "GET #index" do

    it "returns a 200" do
      get :index, collection_id: collection.id, item_id: parent.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template("index")
    end

    it "gets all the items to pass to the view" do
      expect(collection).to receive(:items)
      get :index, collection_id: collection.id, item_id: parent.id
    end
  end


  describe "GET #new" do

    it "returns a 200" do
      allow(parent.children).to receive(:build).and_return(item)

      get :new, collection_id: collection.id, item_id: parent.id
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template("new")
    end

    it "creates a new item " do
      expect(parent.children).to receive(:build).and_return(item)
      get :new, collection_id: collection.id, item_id: parent.id
    end
  end


  describe "POST #create" do
    let(:valid_params) { {collection_id: collection.id, item_id: parent.id, item: { title: 'title' }} }

    before(:each) do
      expect(parent.children).to receive(:build).and_return(item)
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
end
