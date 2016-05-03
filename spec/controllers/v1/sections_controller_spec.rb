require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::SectionsController, type: :controller do
  let(:collection) { instance_double(Collection, id: "1", collection_configuration: "collection_configuration") }
  let(:item) { instance_double(Item, id: "1", children: nil) }
  let(:section) { instance_double(Section, id: "1", updated_at: nil, item: item, collection: collection, showcase: nil) }

  before(:each) do
    allow_any_instance_of(SectionQuery).to receive(:public_find).and_return(section)
    allow_any_instance_of(SectionQuery).to receive(:previous).and_return(nil)
    allow_any_instance_of(SectionQuery).to receive(:next).and_return(nil)
  end

  describe "#show" do
    subject { get :show, id: "id", format: :json }
    it "calls ShowcaseQuery" do
      expect_any_instance_of(SectionQuery).to receive(:public_find).with("id").and_return(section)

      subject
    end

    it "is successful" do
      subject

      expect(response).to be_success
      expect(assigns(:section)).to be_present
      expect(subject).to render_template("v1/sections/show")
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the V1Sections#show to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::V1Sections).to receive(:show)
      subject
    end
  end
end
