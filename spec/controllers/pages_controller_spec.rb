require "rails_helper"
require "cache_spec_helper"

RSpec.describe PagesController, type: :controller do
  let(:page) { instance_double(Page, id: 1, unique_id: 1, name: "name", collection: collection, items: [], destroy!: true) }
  let(:collection) { instance_double(Collection, id: 1, name_line_1: "name_line_1", pages: relation) }

  let(:relation) { Page.all }
  let(:create_params) { { collection_id: collection.id, page: { name: "name", content: "content" } } }
  let(:update_params) { { id: page.id, page: { name: "name", content: "content" } } }

  before(:each) do
    sign_in_admin

    allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
    allow_any_instance_of(PageQuery).to receive(:find).and_return(page)
    allow_any_instance_of(PageQuery).to receive(:public_find).and_return(page)
    allow_any_instance_of(PageQuery).to receive(:build).and_return(page)
    allow(SavePage).to receive(:call).and_return(true)
  end

  describe "GET #index" do
    subject { get :index, collection_id: collection.id }

    it "returns a 200" do
      subject
      expect(response).to be_success
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "users the item query to get items" do
      expect_any_instance_of(PageQuery).to receive(:ordered)
      subject
    end

    it "assigns an item decorator to items" do
      subject
      expect(assigns(:pages)).to be_a(ActiveRecord::Relation)
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the Pages#index to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::Pages).to receive(:index)
      subject
    end
  end

  describe "GET #new" do
    subject { get :new, collection_id: collection.id }

    it "returns a 200" do
      subject
      expect(response).to be_success
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses item query " do
      expect_any_instance_of(PageQuery).to receive(:build).and_return(page)
      subject
    end

    it "assigns and item and it is an item decorator" do
      subject
      expect(assigns(:page)).to eq(page)
    end

    it_behaves_like "a private content-based etag cacher"
  end

  describe "POST #create" do
    subject { post :create, create_params }

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses page query " do
      expect_any_instance_of(PageQuery).to receive(:build).and_return(page)
      subject
    end

    it "redirects on success" do
      subject
      expect(response).to be_redirect
    end

    it "flashes an html_safe message" do
      subject
      expect(flash[:html_safe]).to_not be_nil
    end

    it "renders new on failure" do
      allow(SavePage).to receive(:call).and_return(false)
      subject
      expect(response).to render_template("new")
    end

    it "assigns a page" do
      subject
      assigns(:page)
      expect(assigns(:page)).to eq(page)
    end

    it "uses the save page service" do
      expect(SavePage).to receive(:call).with(page, update_params[:page]).and_return(true)
      subject
    end

    it_behaves_like "a private content-based etag cacher"
  end

  describe "PUT #update" do
    subject { put :update, update_params }

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses page query " do
      expect_any_instance_of(PageQuery).to receive(:find).with("1").and_return(page)
      subject
    end

    it "redirects on success" do
      subject
      expect(response).to be_redirect
    end

    it "flashes a notice" do
      subject
      expect(flash[:notice]).to_not be_nil
    end

    it "renders new on failure" do
      allow(SavePage).to receive(:call).and_return(false)
      subject
      expect(response).to render_template("edit")
    end

    it "assigns a page" do
      subject
      expect(assigns(:page)).to eq(page)
    end

    it "uses the save page service" do
      expect(SavePage).to receive(:call).with(page, update_params[:page]).and_return(true)
      subject
    end

    it_behaves_like "a private content-based etag cacher"
  end

  describe "GET #edit" do
    subject { get :edit, id: page.unique_id }

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses page query " do
      expect_any_instance_of(PageQuery).to receive(:public_find).with("1").and_return(page)
      subject
    end

    it "assigns a page" do
      subject
      expect(assigns(:page)).to eq(page)
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the Pages#default to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::Pages).to receive(:edit)
      subject
    end
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, id: page.id }

    before(:each) do
      allow(DestroyPageItemAssociations).to receive(:call).and_return(1)
    end

    it "on success, redirects" do
      subject
      expect(response).to be_redirect
    end

    it "flashes a notice" do
      subject
      expect(flash[:notice]).to_not be_nil
    end

    it "assigns and item" do
      subject
      expect(assigns(:page)).to eq(page)
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses page query" do
      expect_any_instance_of(PageQuery).to receive(:find).with("1").and_return(page)
      subject
    end

    it "uses the Destroy::Page.cascade method" do
      expect_any_instance_of(Destroy::Page).to receive(:cascade!)
      subject
    end

    it_behaves_like "a private content-based etag cacher"
  end
end
