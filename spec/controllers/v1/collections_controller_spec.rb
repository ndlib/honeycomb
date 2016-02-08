require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::CollectionsController, type: :controller do
  let(:collection) { instance_double(Collection, id: 1, published: false, site_path: "[]") }
  let(:collections) { [collection] }

  before(:each) do
    allow_any_instance_of(CollectionQuery).to receive(:public_collections).and_return(collections)
    allow_any_instance_of(CollectionQuery).to receive(:public_find).and_return(collection)
    allow_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
  end

  describe "#index" do
    subject { get :index, format: :json }
    it "calls CollectionQuery" do
      expect_any_instance_of(CollectionQuery).to receive(:public_collections).and_return(collections)

      subject
    end

    it "is successful" do
      subject

      expect(response).to be_success
      expect(assigns(:collections)).to be_present
      expect(subject).to render_template("v1/collections/index")
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the V1Collections#index to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::V1Collections).to receive(:index)
      subject
    end
  end

  describe "#show" do
    subject { get :show, id: "id", format: :json }
    it "calls CollectionQuery" do
      expect_any_instance_of(CollectionQuery).to receive(:public_find).with("id").and_return(collection)

      subject
    end

    it "is successful" do
      subject

      expect(response).to be_success
      expect(assigns(:collection)).to be_present
      expect(subject).to render_template("v1/collections/show")
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the V1Collections#show to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::V1Collections).to receive(:show)
      subject
    end
  end

  describe "#publish" do
    let(:collection_to_publish) { Collection.new(id: 1) }
    subject { put :publish, collection_id: collection_to_publish.id, format: :json }

    before(:each) do
      sign_in_admin
      allow_any_instance_of(CollectionQuery).to receive(:any_find).with("1").and_return(collection_to_publish)
    end

    it "calls CollectionQuery" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).with("1").and_return(collection_to_publish)
      subject
    end

    it "publishes the collection" do
      expect_any_instance_of(Publish).to receive(:publish!).and_return(true)
      subject
      expect(response.body).to eq("{\"status\":true}")
    end

    it_behaves_like "a private content-based etag cacher"

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:user_can_edit?).with(collection_to_publish)
      subject
    end
  end

  describe "#unpublish" do
    let(:collection_to_unpublish) { Collection.new(id: 1, published: 1) }
    subject { put :unpublish, collection_id: collection_to_unpublish.id, format: :json }

    before(:each) do
      sign_in_admin
      allow_any_instance_of(CollectionQuery).to receive(:any_find).with("1").and_return(collection_to_unpublish)
    end

    it "calls CollectionQuery" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).with("1").and_return(collection_to_unpublish)
      subject
    end

    it "unpublishes the collection" do
      expect_any_instance_of(Unpublish).to receive(:unpublish!).and_return(true)
      subject
      expect(response.body).to eq("{\"status\":true}")
    end

    it_behaves_like "a private content-based etag cacher"

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:user_can_edit?).with(collection_to_unpublish)
      subject
    end
  end

  describe "#preview_mode" do
    let(:collection_to_preview) { Collection.new(id: 1, preview_mode: false) }
    let(:collection_not_to_preview) { Collection.new(id: 2, preview_mode: true) }
    let(:set_preview_mode_true) { put :preview_mode, collection_id: collection_to_preview.id, value: true, format: :json }
    let(:set_preview_mode_false) { put :preview_mode, collection_id: collection_not_to_preview.id, value: false, format: :json }

    before(:each) do
      sign_in_admin
    end

    it "calls CollectionQuery" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).with("1").and_return(collection_to_preview)
      set_preview_mode_true
    end

    it "sets preview mode for collection to true" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).with("1").and_return(collection_to_preview)
      expect_any_instance_of(SetCollectionPreviewMode).to receive(:set_preview_mode).and_return(true)
      set_preview_mode_true
      expect(response.body).to eq("{\"status\":true}")
    end

    it "sets preview mode for collection to false" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).with("2").and_return(collection_not_to_preview)
      expect_any_instance_of(SetCollectionPreviewMode).to receive(:set_preview_mode).and_return(true)
      set_preview_mode_false
      expect(response.body).to eq("{\"status\":true}")
    end

    it "checks the editor permissions" do
      allow_any_instance_of(CollectionQuery).to receive(:any_find).with("1").and_return(collection_to_preview)
      expect_any_instance_of(described_class).to receive(:user_can_edit?).with(collection_to_preview)
      set_preview_mode_true
    end
  end

  describe "#site_path" do
    subject { get :site_path, collection_id: collection.id, format: :json }

    before(:each) do
      allow(Collection).to receive(:find).and_return(collection)
    end

    it "calls CollectionQuery" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
      subject
    end

    it "is successful" do
      subject
      expect(response).to be_success
    end

    it "assigns collection" do
      subject
      expect(assigns(:collection)).to be_present
      expect(subject).to render_template("v1/collections/site_path")
    end

    it "renders the correct template" do
      subject
      expect(subject).to render_template("v1/collections/site_path")
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the V1Collections#site_path to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::V1Collections).to receive(:site_path)
      subject
    end
  end

  describe "#site_path_update" do
    let(:collection) { instance_double(Collection, id: 1, site_path: nil) }
    let(:site_path) { "site_path" }
    let(:site_path_translated) { "site_path_translated" }
    let(:subject) { put :site_path_update, collection_id: collection.id, site_path: site_path, format: :json }

    before(:each) do
      sign_in_admin
      allow_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
      allow(Collection).to receive(:find).and_return(collection)
      allow(SaveCollection).to receive(:call).and_return(true)
      allow_any_instance_of(SiteObjectsQuery).to receive(:public_to_private_json).and_return(site_path_translated)
    end

    it "calls SiteObjectsQuery" do
      expect_any_instance_of(SiteObjectsQuery).to receive(:public_to_private_json).and_return(nil)
      subject
    end

    it "sets the site_path for collection using the string translated by SiteObjectsQuery" do
      expect(SaveCollection).to receive(:call).with(collection, site_path: site_path_translated).and_return(true)
      subject
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:user_can_edit?).with(collection)
      subject
    end
  end
end
