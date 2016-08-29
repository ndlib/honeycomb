require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::PagesController, type: :controller do
  let(:collection) { instance_double(Collection, id: "1", updated_at: nil, pages: nil, collection_configuration: "collection_configuration") }
  let(:page) { instance_double(Page, id: "1", updated_at: nil, collection: collection, items: []) }
  let(:update_params) { { id: page.id, page: { name: "name", content: "content" } } }

  before(:each) do
    sign_in_admin

    allow_any_instance_of(PageQuery).to receive(:public_find).and_return(page)
    allow_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
    allow(SavePage).to receive(:call).and_return(true)
  end

  describe "#index" do
    subject { get :index, collection_id: collection.id, format: :json }
    it "calls CollectionQuery" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).with(collection.id).and_return(collection)

      subject
    end

    it "is successful" do
      subject
      expect(response).to be_success
    end

    it "assigns collection" do
      subject
      expect(assigns(:collection)).to be_present
    end

    it "renders the correct view" do
      subject
      expect(subject).to render_template("v1/pages/index")
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the V1Pages#index to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::V1Pages).to receive(:index)
      subject
    end
  end

  describe "#show" do
    subject { get :show, id: "id", format: :json }

    before(:each) do
      allow_any_instance_of(V1::PageJSONDecorator).to receive(:next).and_return(nil)
    end

    it "calls PageQuery" do
      expect_any_instance_of(PageQuery).to receive(:public_find).with("id").and_return(page)

      subject
    end

    it "is successful" do
      subject
      expect(response).to be_success
    end

    it "assigns page" do
      subject
      expect(assigns(:page)).to be_present
    end

    it "renders the correct view" do
      subject
      expect(subject).to render_template("v1/pages/show")
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the V1Pages#show to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::V1Pages).to receive(:show)
      subject
    end
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
end
