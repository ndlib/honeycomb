require "rails_helper"

RSpec.describe CollectionsController, :type => :controller do
  let(:collection) { instance_double(Collection, id: 1, title: "COLLECTION", destroy!: true ) }

  let(:create_params) { { collection: {title: "TITLE!!" }} }
  let(:update_params) { { id: '1', collection: {title: "TITLE!!" }} }

  let(:user) {
    u = User.new(username: 'jhartzler', admin: true)
    u.save!

    u
  }

  before(:each) do
    sign_in user
  end

  describe "index" do
    subject { get :index }

    it "uses the query object" do
      expect_any_instance_of(CollectionQuery).to receive(:for_editor).with(user)
      subject
    end


    it "is a success" do
      subject

      expect(response).to be_success
      expect(response).to render_template("index")
    end
  end

  describe "show" do
    subject { get :show, id: collection.id }
    it "redirects to the items page" do
      subject

      expect(response).to redirect_to collection_items_path(collection.id)
    end
  end

  describe "new" do

    it "checks the admin permissions" do
      expect_any_instance_of(described_class).to receive(:check_admin_or_admin_masquerading_permission!)
      get :new
    end

    it "calls CollectionQuery to get the collection" do
      expect_any_instance_of(CollectionQuery).to receive(:build).and_return(Collection.new)
      get :new
    end

    it "loads a new collection" do
      get :new
      assigns(:collection)
      expect(assigns(:collection)).to be_a(Collection)
    end

    it "is a success" do
      get :new
      expect(response).to be_success
    end
  end


  describe "create" do
    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:build).and_return(collection)
      allow(SaveCollection).to receive(:call).and_return(true)
    end

    it "checks the admin permissions" do
      expect_any_instance_of(described_class).to receive(:check_admin_or_admin_masquerading_permission!)
      post :create, create_params
    end

    it "calls the save service" do
      expect(SaveCollection).to receive(:call)
      post :create, create_params
    end

    it "assigns a collection" do
      post :create, create_params

      assigns(:collection)
      expect(assigns(:collection)).to eq(collection)
    end

    it "redirects on success" do
      post :create, create_params
      expect(response).to be_redirect
    end

    it "renders new on failure" do
      allow(SaveCollection).to receive(:call).and_return(false)

      post :create, create_params
      expect(response).to render_template(:new)
    end
  end


  describe "edit" do
    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      get :edit, id: 1
    end

    it "uses collection query to get the colletion" do
      expect_any_instance_of(CollectionQuery).to receive(:find).with("1").and_return(collection)
      get :edit, id: 1
    end

    it "is a success" do
      get :edit, id: 1
      expect(response).to be_success
    end
  end

  describe "update" do
    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
      allow(SaveCollection).to receive(:call).and_return(true)
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      put :update, update_params
    end

    it "uses collection query to get the colletion" do
      expect_any_instance_of(CollectionQuery).to receive(:find).with("1").and_return(collection)
      put :update, update_params
    end

    it "assigns a collection" do
      put :update, update_params

      assigns(:collection)
      expect(assigns(:collection)).to eq(collection)
    end

    it "redirects on success" do
      put :update, update_params
      expect(response).to be_redirect
    end

    it "renders new on failure" do
      allow(SaveCollection).to receive(:call).and_return(false)

      put :update, update_params
      expect(response).to render_template(:edit)
    end
  end


  describe "destroy" do
    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
    end

    it "checks admin permissions" do
      expect_any_instance_of(described_class).to receive(:check_admin_or_admin_masquerading_permission!)

      delete :destroy, id: "1"
    end

    it "uses collection query to get the colletion" do
      expect_any_instance_of(CollectionQuery).to receive(:find).with("1").and_return(collection)
      delete :destroy, id: "1"
    end

    it "redirects on success " do
      delete :destroy, id: "1"
      expect(response).to be_redirect
    end
  end


  describe "exhibit" do
    subject { get :exhibit, collection_id: collection.id }
    let(:exhibit) { instance_double(Exhibit, id: 1)}

    before(:each) do
      allow(collection).to receive(:exhibit).and_return(exhibit)
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
    end


    it "uses collection query" do
      expect_any_instance_of(CollectionQuery).to receive(:find).with("1").and_return(collection)
      subject
    end

    it "ensures the collection has an exhibit" do
      expect(EnsureCollectionHasExhibit).to receive(:call).with(collection).and_return(exhibit)
      subject
    end
  end
end
