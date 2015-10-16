require "rails_helper"
require "cache_spec_helper"

RSpec.describe ShowcasesController, type: :controller do
  let(:showcase) { instance_double(Showcase, id: 1, name_line_1: "name_line_1", collection: collection, sections: [], destroy!: true) }
  let(:collection) { instance_double(Collection, id: 1, name_line_1: "name_line_1", showcases: relation) }

  let(:relation) { Showcase.all }
  let(:create_params) { { collection_id: collection.id, showcase: { name_line_1: "name_line_1", description: "description" } } }
  let(:update_params) { { id: showcase.id, showcase: { name_line_1: "name_line_1", description: "description" } } }

  before(:each) do
    sign_in_admin

    allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
    allow_any_instance_of(ShowcaseQuery).to receive(:find).and_return(showcase)
    allow_any_instance_of(ShowcaseQuery).to receive(:build).and_return(showcase)
    allow(SaveShowcase).to receive(:call).and_return(true)
  end

  describe "GET #index" do
    subject { get :index, collection_id: collection.id }

    it "returns a 200" do
      subject

      expect(response).to be_success
      expect(response).to render_template("index")
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "users the item query to get items" do
      expect_any_instance_of(ShowcaseQuery).to receive(:admin_list)
      subject
    end

    it "assigns an item decorator to items" do
      subject
      assigns(:showcases)
      expect(assigns(:showcases)).to be_a(ActiveRecord::Relation)
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the Showcases#index to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::Showcases).to receive(:index)
      subject
    end
  end

  describe "GET #new" do
    subject { get :new, collection_id: collection.id }

    it "returns a 200" do
      subject

      expect(response).to be_success
      expect(response).to render_template("new")
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses item query " do
      expect_any_instance_of(ShowcaseQuery).to receive(:build).and_return(showcase)
      subject
    end

    it "assigns and item and it is an item decorator" do
      subject

      assigns(:showcase)
      expect(assigns(:showcase)).to eq(showcase)
    end

    it_behaves_like "a private content-based etag cacher"
  end

  describe "POST #create" do
    subject { post :create, create_params }

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses showcase query " do
      expect_any_instance_of(ShowcaseQuery).to receive(:build).and_return(showcase)
      subject
    end

    it "redirects on success" do
      subject

      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "renders new on failure" do
      allow(SaveShowcase).to receive(:call).and_return(false)

      subject
      expect(response).to render_template("new")
    end

    it "assigns a showcase" do
      subject

      assigns(:showcase)
      expect(assigns(:showcase)).to eq(showcase)
    end

    it "uses the save showcase service" do
      expect(SaveShowcase).to receive(:call).with(showcase, update_params[:showcase]).and_return(true)

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

    it "uses showcase query " do
      expect_any_instance_of(ShowcaseQuery).to receive(:find).with("1").and_return(showcase)
      subject
    end

    it "redirects on success" do
      subject

      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "renders new on failure" do
      allow(SaveShowcase).to receive(:call).and_return(false)

      subject
      expect(response).to render_template("edit")
    end

    it "assigns a showcase" do
      subject

      assigns(:showcase)
      expect(assigns(:showcase)).to eq(showcase)
    end

    it "uses the save showcase service" do
      expect(SaveShowcase).to receive(:call).with(showcase, update_params[:showcase]).and_return(true)

      subject
    end

    it_behaves_like "a private content-based etag cacher"
  end

  describe "GET #show" do
    subject { get :show, id: showcase.id }

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses showcase query " do
      expect_any_instance_of(ShowcaseQuery).to receive(:find).with("1").and_return(showcase)
      subject
    end

    it "assigns a showcase decorator" do
      subject

      expect(assigns(:showcase)).to be_a_kind_of(ShowcaseDecorator)
    end

    it "is a redirect" do
      subject

      expect(response).to be_redirect
    end

    it "renders json" do
      get :show, id: showcase.id, format: :json

      expect(response).to be_success
    end

    it_behaves_like "a private content-based etag cacher"
  end

  describe "GET #edit" do
    subject { get :edit, id: showcase.id }

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses showcase query " do
      expect_any_instance_of(ShowcaseQuery).to receive(:find).with("1").and_return(showcase)
      subject
    end

    it "assigns a showcase" do
      subject

      assigns(:showcase)
      expect(assigns(:showcase)).to eq(showcase)
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the Showcases#default to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::Showcases).to receive(:edit)
      subject
    end
  end

  describe "GET #title" do
    subject { get :title, id: showcase.id }

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses showcase query " do
      expect_any_instance_of(ShowcaseQuery).to receive(:find).with("1").and_return(showcase)
      subject
    end

    it "assigns a showcase" do
      subject

      assigns(:showcase)
      expect(assigns(:showcase)).to eq(showcase)
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the Showcases#default to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::Showcases).to receive(:title)
      subject
    end
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, id: showcase.id }

    it "on success, redirects, and flashes " do
      subject
      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "assigns and item" do
      subject

      assigns(:showcase)
      expect(assigns(:showcase)).to eq(showcase)
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses showcase query " do
      expect_any_instance_of(ShowcaseQuery).to receive(:find).with("1").and_return(showcase)
      subject
    end

    it "uses the Destroy::Showcase.cascade method" do
      expect_any_instance_of(Destroy::Showcase).to receive(:cascade!)
      subject
    end

    it_behaves_like "a private content-based etag cacher"
  end

  describe "PUT #publish" do
    subject { put :publish, id: showcase.id }

    it_behaves_like "a private content-based etag cacher" do
      before do
        allow(Publish).to receive(:call).and_return true
      end
    end
  end

  describe "PUT #unpublish" do
    subject { put :unpublish, id: showcase.id }

    it_behaves_like "a private content-based etag cacher" do
      before do
        allow(Unpublish).to receive(:call).and_return true
      end
    end
  end
end
