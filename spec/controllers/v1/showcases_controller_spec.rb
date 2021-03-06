require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::ShowcasesController, type: :controller do
  let(:collection) { instance_double(Collection, id: "1", updated_at: nil, showcases: nil, collection_configuration: "collection_configuration") }
  let(:showcase) { instance_double(Showcase, id: "1", updated_at: nil, sections: [], items: [], items_media: [], collection: collection, destroy!: true) }

  before(:each) do
    allow_any_instance_of(ShowcaseQuery).to receive(:public_find).and_return(showcase)
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
      expect(assigns(:collection)).to be_present
      expect(subject).to render_template("v1/showcases/index")
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the V1Showcases#index to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::V1Showcases).to receive(:index)
      subject
    end
  end

  describe "#show" do
    subject { get :show, id: "id", format: :json }

    before(:each) do
      allow_any_instance_of(V1::ShowcaseJSONDecorator).to receive(:sections).and_return([])
      allow_any_instance_of(V1::ShowcaseJSONDecorator).to receive(:next).and_return(nil)
    end

    it "calls ShowcaseQuery" do
      expect_any_instance_of(ShowcaseQuery).to receive(:public_find).with("id").and_return(showcase)

      subject
    end

    it "is successful" do
      subject

      expect(response).to be_success
      expect(assigns(:showcase)).to be_present
      expect(subject).to render_template("v1/showcases/show")
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the V1Showcases#show to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::V1Showcases).to receive(:show)
      subject
    end
  end

  describe "#destroy" do
    subject { delete :destroy, id: showcase.id, format: :json }

    before(:each) do
      sign_in_admin
      allow_any_instance_of(SiteObjectsQuery).to receive(:exists?).and_return(false)
    end

    it "is successful" do
      subject

      expect(response).to be_success
    end

    it "uses showcase query " do
      expect_any_instance_of(ShowcaseQuery).to receive(:public_find).with("1").and_return(showcase)
      subject
    end

    it "uses the Destroy::Showcase.cascade method" do
      expect_any_instance_of(Destroy::Showcase).to receive(:cascade!)
      subject
    end
  end
end
