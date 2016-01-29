require "rails_helper"
require "cache_spec_helper"

RSpec.describe CollectionsController, type: :controller do
  let(:collection) { instance_double(Collection, id: 1, name_line_1: "COLLECTION", destroy!: true, collection_users: [], showcases: [], pages: [], items: []) }

  let(:create_params) { { collection: { name_line_1: "TITLE!!" } } }
  let(:update_params) { { id: "1", published: true, collection: { name_line_1: "TITLE!!" } } }

  before(:each) do
    @user = sign_in_admin
  end

  describe "index" do
    subject { get :index }

    it "uses the query object" do
      expect_any_instance_of(CollectionQuery).to receive(:for_editor).with(@user)
      subject
    end

    it "is a success" do
      subject

      expect(response).to be_success
      expect(response).to render_template("index")
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the Collections#index to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::Collections).to receive(:index)
      subject
    end
  end

  describe "show" do
    subject { get :show, id: collection.id }
    it "redirects to the items page" do
      subject

      expect(response).to redirect_to collection_items_path(collection.id)
    end

    it_behaves_like "a private content-based etag cacher"
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

    it_behaves_like "a private content-based etag cacher" do
      subject { get :new }
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

    it_behaves_like "a private content-based etag cacher" do
      subject { post :create, create_params }
    end
  end

  describe "settings" do
    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      get :settings, id: 1
    end

    it "uses collection query to get the colletion" do
      expect_any_instance_of(CollectionQuery).to receive(:find).with("1").and_return(collection)
      get :settings, id: 1
    end

    it "is a success" do
      get :settings, id: 1
      expect(response).to be_success
    end

    it_behaves_like "a private basic custom etag cacher" do
      subject { get :settings, id: 1 }
    end

    it "uses the Collections#settings to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::Collections).to receive(:settings)
      get :settings, id: 1
    end
  end

  describe "settings_update" do
    let(:update_params) { { id: "1", published: true, form: "general", collection: { name_line_1: "TITLE!!" } } }
    subject { put :settings_update, update_params }

    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
      allow(SaveCollection).to receive(:call).and_return(true)
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses collection query to get the collection" do
      expect_any_instance_of(CollectionQuery).to receive(:find).with("1").and_return(collection)
      subject
    end

    it "assigns a collection" do
      subject

      assigns(:collection)
      expect(assigns(:collection)).to eq(collection)
    end

    it "redirects on success" do
      subject
      expect(response).to be_redirect
    end

    it "renders new on failure" do
      allow(SaveCollection).to receive(:call).and_return(false)

      subject
      expect(response).to render_template(:settings)
    end

    it_behaves_like "a private content-based etag cacher"
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

    it "uses the Destroy::Collection.cascade! method" do
      expect_any_instance_of(Destroy::Collection).to receive(:cascade!)
      delete :destroy, id: "1"
    end

    it_behaves_like "a private content-based etag cacher" do
      subject { delete :destroy, id: "1" }
    end
  end

  describe "publish" do
    let(:collection_to_publish) { Collection.new(id: 1) }

    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection_to_publish)
      allow(collection_to_publish).to receive(:save).and_return(true)
    end

    it "checks the editor permissions" do
      expect_any_instance_of(CollectionsController).to receive(:check_user_edits!).with(collection_to_publish)
      put :publish, update_params
    end

    it "uses collection query to get the colletion" do
      expect_any_instance_of(CollectionQuery).to receive(:find).with("1").and_return(collection_to_publish)
      put :publish, update_params
    end

    it "publishes a collection" do
      put :publish, update_params
      expect(collection_to_publish.published).to be_truthy
    end

    it "redirects on success" do
      put :publish, update_params
      expect(response).to be_redirect
    end
  end

  describe "unpublish" do
    let(:collection_to_unpublish) { Collection.new(id: 1, published: true) }

    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection_to_unpublish)
      allow(collection_to_unpublish).to receive(:save).and_return(true)
      update_params[:published] = false
    end

    it "checks the editor permissions" do
      expect_any_instance_of(CollectionsController).to receive(:check_user_edits!).with(collection_to_unpublish)
      put :unpublish, update_params
    end

    it "uses collection query to get the colletion" do
      expect_any_instance_of(CollectionQuery).to receive(:find).with("1").and_return(collection_to_unpublish)
      put :unpublish, update_params
    end

    it "unpublishes a collection" do
      put :unpublish, update_params
      expect(collection_to_unpublish.published).to be_falsey
    end

    it "redirects on success" do
      put :unpublish, update_params
      expect(response).to be_redirect
    end
  end

  describe "site_setup" do
    subject { get :site_setup, id: collection.id }
    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
    end

    it "checks the curator permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses collection query" do
      expect_any_instance_of(CollectionQuery).to receive(:find).with("1").and_return(collection)
      subject
    end

    it "assigns a collection" do
      subject

      assigns(:collection)
      expect(assigns(:collection)).to eq(collection)
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the Collection#site_setup to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::Collections).to receive(:site_setup)
      subject
    end
  end

  describe "site_setup_update" do
    let(:update_params) { { id: "1", published: true, form: "homepage", collection: { name_line_1: "TITLE!!" } } }
    subject { put :site_setup_update, update_params }

    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
      allow(SaveCollection).to receive(:call).and_return(true)
    end

    it "checks the curator permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses collection query " do
      expect_any_instance_of(CollectionQuery).to receive(:find).with("1").and_return(collection)
      subject
    end

    it "redirects on success" do
      subject

      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "renders new on failure" do
      allow(SaveCollection).to receive(:call).and_return(false)

      subject
      expect(response).to render_template("site_setup")
    end

    it "assigns a collection" do
      subject

      assigns(:collection)
      expect(assigns(:collection)).to eq(collection)
    end

    it "uses the save collection service" do
      expect(SaveCollection).to receive(:call).with(collection, update_params[:collection]).and_return(true)

      subject
    end

    it_behaves_like "a private content-based etag cacher"
  end
end
