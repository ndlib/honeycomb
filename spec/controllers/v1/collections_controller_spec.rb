require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::CollectionsController, type: :controller do
  let(:collection) { instance_double(Collection, id: 1, published: false, site_objects: "[]") }
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

  describe "#site_objects" do
    subject { get :site_objects, collection_id: collection.id, format: :json }

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
      expect(subject).to render_template("v1/collections/site_objects")
    end

    it "renders the correct template" do
      subject
      expect(subject).to render_template("v1/collections/site_objects")
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the V1Collections#site_objects to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::V1Collections).to receive(:site_objects)
      subject
    end
  end

  describe "metadata_configuration" do
    let(:collection) { Collection.new(id: 1) }
    let(:collection_configuration) { double(CollectionConfiguration) }
    subject { get :metadata_configuration, collection_id: 1, format: :json }

    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
      allow_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(collection_configuration)
      allow_any_instance_of(V1::MetadataConfigurationJSON).to receive(:to_json).and_return("JSON")
    end

    it "calls to json on the V1::MetadataConfigurationJSON" do
      expect_any_instance_of(V1::MetadataConfigurationJSON).to receive(:to_json)
      subject
    end

    it "queries for the collection" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
      subject
    end

    it "queries for the configuration" do
      expect_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(collection_configuration)
      subject
    end
  end

  describe "#site_objects_update" do
    let(:collection) { instance_double(Collection, id: 1, site_objects: nil) }
    let(:site_objects) { "site_objects" }
    let(:site_objects_translated) { "site_objects_translated" }
    let(:subject) { put :site_objects_update, collection_id: collection.id, site_objects: site_objects, format: :json }

    before(:each) do
      sign_in_admin
      allow_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
      allow(Collection).to receive(:find).and_return(collection)
      allow(SaveCollection).to receive(:call).and_return(true)
      allow_any_instance_of(SiteObjectsQuery).to receive(:public_to_private_json).and_return(site_objects_translated)
    end

    it "calls SiteObjectsQuery" do
      expect_any_instance_of(SiteObjectsQuery).to receive(:public_to_private_json).and_return(nil)
      subject
    end

    it "sets the site_objects for collection using the string translated by SiteObjectsQuery" do
      expect(SaveCollection).to receive(:call).with(collection, site_objects: site_objects_translated).and_return(true)
      subject
    end
  end
end
