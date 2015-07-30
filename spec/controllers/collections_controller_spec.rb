require "rails_helper"
require "cache_spec_helper"
require "google_drive/spreadsheet"

RSpec.describe CollectionsController, type: :controller do
  let(:collection) { instance_double(Collection, id: 1, name_line_1: "COLLECTION", destroy!: true, collection_users: [], exhibit: nil, items: []) }

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

    it_behaves_like "a private basic custom etag cacher" do
      subject { get :edit, id: 1 }
    end

    it "uses the Collections#edit to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::Collections).to receive(:edit)
      get :edit, id: 1
    end
  end

  describe "get_authorization_uri" do
    let(:state_hash) { { collection_id: "1", file: "test.file", sheet: "test.sheet" } }
    let(:param_hash) { { state_hash: state_hash } }

    it "uses google api to request an auth uri" do
      expect_any_instance_of(GoogleSession).to receive(:auth_request_uri).with(hash_including(param_hash))
      get :get_authorization_uri, id: 1, file_name: state_hash[:file], sheet_name: state_hash[:sheet]
    end

    it "renders a json with the auth_uri" do
      get :get_authorization_uri, id: 1, file_name: "test.file", sheet_name: "test.sheet"
      expect(JSON.parse(response.body)).to include("auth_uri")
    end
  end

  describe "import_google_sheet_callback" do
    let(:state_hash) { { collection_id: "1", file: "test.file", sheet: "test.sheet" } }
    let(:encoded_state_hash) { Base64::encode64(state_hash.to_json) }
    let(:worksheet) { instance_double(GoogleDrive::Worksheet, rows: []) }

    it "uses google api to retrieve the worksheet" do
      allow_any_instance_of(GoogleSession).to receive(:connect)
      expect_any_instance_of(GoogleSession).to receive(:get_worksheet).with(file: state_hash[:file], sheet: state_hash[:sheet]).and_return(nil)
      get :import_google_sheet_callback, state: encoded_state_hash
    end

    it "gets the rows of the worksheet" do
      allow_any_instance_of(GoogleSession).to receive(:connect)
      allow_any_instance_of(GoogleSession).to receive(:get_worksheet).and_return(worksheet)
      expect(worksheet).to receive(:rows)
      get :import_google_sheet_callback, state: encoded_state_hash
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

    it_behaves_like "a private content-based etag cacher" do
      subject { put :update, update_params }
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

    it "uses the Destroy::Collection.cascade! method" do
      expect_any_instance_of(Destroy::Collection).to receive(:cascade!)
      delete :destroy, id: "1"
    end

    it_behaves_like "a private content-based etag cacher" do
      subject { delete :destroy, id: "1" }
    end
  end

  describe "exhibit" do
    subject { get :exhibit, collection_id: collection.id }
    let(:exhibit) { instance_double(Exhibit, id: 1) }

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

    it_behaves_like "a private content-based etag cacher"
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
end
