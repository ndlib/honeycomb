require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::PagesController, type: :controller do
  let(:collection) { instance_double(Collection, id: "1", updated_at: nil, pages: nil, collection_configuration: "collection_configuration") }
  let(:page) { instance_double(Page, id: "1", updated_at: nil, collection: collection, items: [], destroy!: true) }

  before(:each) do
    allow_any_instance_of(PageQuery).to receive(:public_find).and_return(page)
    allow_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
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

  describe "#destroy" do
    subject { delete :destroy, id: "id", format: :json }

    before(:each) do
      sign_in_admin
      allow(DestroyPageItemAssociations).to receive(:call).and_return(1)
    end

    it "is successful" do
      subject

      expect(response).to be_success
    end

    it "uses page query " do
      expect_any_instance_of(PageQuery).to receive(:public_find).with("id").and_return(page)
      subject
    end

    it "uses the Destroy::page.cascade method" do
      expect_any_instance_of(Destroy::Page).to receive(:cascade!)
      subject
    end
  end
end
