require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::ItemsController, type: :controller do
  let(:collection) { instance_double(Collection, id: "1", updated_at: nil, items: nil) }
  let(:item) { instance_double(Item, id: "1", collection: nil, children: nil) }

  before(:each) do
    allow_any_instance_of(ItemQuery).to receive(:public_find).and_return(item)
    allow_any_instance_of(CollectionQuery).to receive(:public_find).and_return(collection)
  end

  describe "#index" do
    subject { get :index, collection_id: collection.id, format: :json }
    it "calls CollectionQuery" do
      expect_any_instance_of(CollectionQuery).to receive(:public_find).with(collection.id).and_return(collection)

      subject
    end

    it "is successful" do
      subject

      expect(response).to be_success
      expect(assigns(:collection)).to be_present
      expect(subject).to render_template("v1/items/index")
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the V1Items#index to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::V1Items).to receive(:index)
      subject
    end
  end

  describe "#show" do
    subject { get :show, id: "id", format: :json }
    it "calls ItemQuery" do
      expect_any_instance_of(ItemQuery).to receive(:public_find).with("id").and_return(item)

      subject
    end

    it "is successful" do
      subject

      expect(response).to be_success
      expect(assigns(:item)).to be_present
      expect(subject).to render_template("v1/items/show")
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the V1Items#show to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::V1Items).to receive(:show)
      subject
    end
  end

  describe "PUT #update" do
    let(:collection) { double(Collection, id: "1") }
    let(:item) { double(Item, id: 1, parent: nil, collection: collection,  errors: "Errors" ) }
    let(:update_params) { { format: :json, id: item.id, item: { title: "title" } } }

    subject { put :update, update_params }

    before(:each) do
      sign_in_admin
      allow_any_instance_of(ItemQuery).to receive(:find).and_return(item)
      allow(SaveItem).to receive(:call).and_return(true)
    end

    #it "checks the editor permissions" do
    #  expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
    #  subject
    #end

    it "uses item query " do
      expect_any_instance_of(ItemQuery).to receive(:find).with("1").and_return(item)
      subject
    end

    it "renders the item on success" do
      subject
      expect(response).to render_template("show")
    end

    it "unprocessable on failure" do
      allow(SaveItem).to receive(:call).and_return(false)
      subject
      expect(response).to be_unprocessable
    end

    it "assigns and item" do
      subject

      assigns(:item)
      expect(assigns(:item)).to eq(item)
    end

    it "uses the save item service" do
      expect(SaveItem).to receive(:call).and_return(true)

      subject
    end

    it_behaves_like "a private content-based etag cacher"
  end
end
