require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::ItemsController, type: :controller do
  let(:collection_configuration) { CollectionConfiguration.new }
  let(:collection) { instance_double(Collection, id: "1", updated_at: nil, items: nil, collection_configuration: collection_configuration) }
  let(:item) { instance_double(Item, id: "1", collection: collection, children: nil) }

  before(:each) do
    allow_any_instance_of(ItemQuery).to receive(:public_find).and_return(item)
    allow_any_instance_of(CollectionQuery).to receive(:public_find).and_return(collection)
  end

  describe "#index" do
    subject { get :index, collection_id: collection.id, format: :json }
    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
    end

    it "calls CollectionQuery" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).with(collection.id).and_return(collection)

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
    let(:collection_configuration) { CollectionConfiguration.new }
    let(:collection) { double(Collection, id: "1", collection_configuration: collection_configuration) }
    let(:item) { instance_double(Item, id: 1, parent: nil, collection: collection) }
    let(:update_params) { { format: :json, id: item.id, item: { name: "item" } } }
    let(:base_config) do
      c = CreateCollectionConfiguration.new("")
      c.send(:base_config)
    end
    subject { put :update, update_params }

    before(:each) do
      sign_in_admin
      allow(SaveItem).to receive(:call).and_return(true)
      allow_any_instance_of(ItemQuery).to receive(:find).and_return(item)
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:user_can_edit?).with(collection)
      subject
    end

    it "uses item query " do
      expect_any_instance_of(ItemQuery).to receive(:public_find).with("1").and_return(item)
      subject
    end

    it "returns ok on success" do
      subject
      expect(response).to be_success
    end

    it "renders the item only on success" do
      subject
      expect(response).to render_template("update")
    end

    it "returns unprocessable on failure" do
      allow(SaveItem).to receive(:call).and_return(false)
      subject
      expect(response).to be_unprocessable
    end

    it "renders with errors" do
      allow(SaveItem).to receive(:call).and_return(false)
      subject
      expect(item).to render_template("errors")
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

  describe "#create" do
    let(:collection_configuration) { CollectionConfiguration.new }
    let(:collection) { Collection.new(unique_id: "test", items: [], collection_configuration: collection_configuration) }
    let(:item) { Item.new(id: 1, unique_id: "test", collection: collection) }
    let(:image) { double(path: Rails.root.join("spec/fixtures/test.jpg").to_s, content_type: "image/jpeg") }
    let(:image_params) { { collection_id: "test", item: { uploaded_image: fixture_file_upload("test.jpg", "image/jpeg", :binary) }, format: :json } }
    subject { post :create, image_params }

    before(:each) do
      sign_in_admin
      allow_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
      allow_any_instance_of(ItemQuery).to receive(:find).and_return(item)
      allow(Item).to receive(:last).and_return(item)
      expect_any_instance_of(ItemQuery).to receive(:build).and_return(item)
    end

    context "when successfully uploaded" do
      it "uploads the image" do
        expect(SaveItem).to receive(:call).and_return(true)
        subject
        expect(response).to be_success
      end
    end

    context "when not successfully uploaded" do
      it "does not return success" do
        expect(SaveItem).to receive(:call).and_return(false)
        subject
        expect(response).to be_unprocessable
      end

      it "returns the error json" do
        expect(SaveItem).to receive(:call).and_return(false)
        subject
        expect(item).to render_template("errors")
      end
    end
  end

  describe "#showcases" do
    let(:collection_configuration) { CollectionConfiguration.new }
    let(:collection) { Collection.new(unique_id: "test", items: [], collection_configuration: collection_configuration) }
    subject { get :showcases, item_id: "id", format: :json }
    let(:item) { instance_double(Item, id: "1", collection: collection, children: nil, showcases: nil) }

    it "calls ItemQuery" do
      expect_any_instance_of(ItemQuery).to receive(:public_find).with("id").and_return(item)

      subject
    end

    it "is successful" do
      subject
      expect(response).to be_success
    end

    it "assigns the item to render" do
      subject
      expect(assigns(:item)).to be_present
    end

    it "renders the correct template" do
      expect(subject).to render_template("v1/items/showcases")
      subject
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the V1Items#showcases to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::V1Items).to receive(:showcases)
      subject
    end
  end
end
