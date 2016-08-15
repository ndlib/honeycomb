require "rails_helper"
require "cache_spec_helper"

RSpec.describe ItemsController, type: :controller do
  let(:relation) { Item.all }

  let(:publish_params) { { id: item.id } }

  before(:each) do
    sign_in_admin
  end

  describe "GET #index" do
    let(:collection) { double(Collection, id: 1, items: relation) }

    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
    end

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
      expect_any_instance_of(ItemQuery).to receive(:only_top_level).and_return([])
      subject
    end

    it "assigns an item decorator to items" do
      subject
      assigns(:items)
      expect(assigns(:items)).to be_a(ItemsDecorator)
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the Items#index to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::Items).to receive(:index)
      subject
    end
  end

  describe "POST #create" do
    let(:collection) { double(Collection, id: 1, items: relation) }
    let(:create_params) { { collection_id: collection.id, item: { metadata: { name: "name" } } } }
    let(:item) { instance_double(Item, id: 1, parent: nil, collection: collection) }

    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
      allow_any_instance_of(ItemQuery).to receive(:build).and_return(item)
      allow(SaveItem).to receive(:call).and_return(true)
    end

    subject { post :create, create_params, format: :json }

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses item query " do
      expect_any_instance_of(ItemQuery).to receive(:build).and_return(item)
      subject
    end

    it "redirects on success" do
      expect_any_instance_of(described_class).to receive(:item_save_success).and_call_original

      subject

      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
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

  describe "GET #edit" do
    let(:collection) { double(Collection, id: "1") }
    let(:item) { instance_double(Item, id: "1", collection: collection, pages: ["page1", "page2"]) }

    before(:each) do
      allow_any_instance_of(ItemDecorator).to receive(:recent_children).and_return(nil)
      allow_any_instance_of(ItemDecorator).to receive(:showcases).and_return(nil)
      allow_any_instance_of(ItemQuery).to receive(:public_find).and_return(item)
    end

    subject { get :edit, id: item.id }

    it "returns a 200" do
      subject

      expect(response).to be_success
      expect(response).to render_template("edit")
    end

    it "uses item query" do
      expect_any_instance_of(ItemQuery).to receive(:public_find).with("1").and_return(item)
      subject
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "assigns and item and it is an item decorator" do
      subject

      assigns(:item)
      expect(assigns(:item)).to be_a(ItemDecorator)
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the Items#edit to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::Items).to receive(:edit)
      subject
    end
  end
end
