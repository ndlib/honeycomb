require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::CollectionsController, type: :controller do
  let(:collection) { instance_double(Collection, id: 1, published: false) }
  let(:collections) { [collection] }

  before(:each) do
    allow_any_instance_of(CollectionQuery).to receive(:public_collections).and_return(collections)
    allow_any_instance_of(CollectionQuery).to receive(:public_find).and_return(collection)
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
    let(:set_preview_mode_true) { put :preview_mode, 
                  collection_id: collection_to_preview.id,
                  value: true,
                  format: :json }
    let(:set_preview_mode_false) { put :preview_mode, 
                  collection_id: collection_not_to_preview.id,
                  value: false,
                  format: :json }

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
  end
end
