require "rails_helper"
require "cache_spec_helper"

RSpec.describe SectionsController, type: :controller do
  let(:showcase) { double(Showcase, id: 1, name: "name", sections: relation, collection: collection) }
  let(:collection) { instance_double(Collection, id: 1, name_line_1: "name_line_1") }
  let(:section) { double(Section, id: 1, destroy!: true, showcase: showcase, :order= => true, order: 1, collection: collection, "item=" => true) }
  let(:item) { instance_double(Item) }
  let(:relation) { Section.all }
  let(:create_params) { { showcase_id: showcase.id, section: { name: "name", order: 1 } } }

  let(:update_params) { { id: section.id, section: { name: "name" } } }

  before(:each) do
    sign_in_admin
    allow_any_instance_of(ItemQuery).to receive(:public_find).and_return(item)
    allow_any_instance_of(ShowcaseQuery).to receive(:find).and_return(showcase)
    allow_any_instance_of(SectionQuery).to receive(:build).and_return(section)
    allow_any_instance_of(SectionQuery).to receive(:find).and_return(section)

    allow(SaveSection).to receive(:call).and_return(true)
  end

  describe "POST #create" do
    subject { post :create, create_params }

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses item query " do
      expect_any_instance_of(ItemQuery).to receive(:public_find).and_return(item)
      subject
    end

    it "associates the item found via the item query " do
      allow_any_instance_of(ItemQuery).to receive(:public_find).and_return(item)
      expect(section).to receive("item=").with(item)
      subject
    end

    it "redirects on success" do
      subject

      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "renders new on failure" do
      allow(SaveSection).to receive(:call).and_return(false)

      subject
      expect(response).to render_template("new")
    end

    it "assigns and item" do
      subject

      assigns(:section)
      expect(assigns(:section)).to eq(section)
    end

    it "uses the save item service" do
      expect(SaveSection).to receive(:call).and_return(true)

      subject
    end

    it_behaves_like "a private content-based etag cacher"
  end

  describe "GET #edit" do
    subject { get :edit, id: 1 }

    it "returns a 200" do
      subject

      expect(response).to be_success
      expect(response).to render_template("edit")
    end

    it "uses item query" do
      expect_any_instance_of(SectionQuery).to receive(:find).with("1").and_return(section)
      subject
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "assigns and item and it is an item decorator" do
      subject

      assigns(:section_form)
      expect(assigns(:section_form)).to be_a(SectionForm)
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the Sections#edit to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::Sections).to receive(:edit)
      subject
    end
  end

  describe "PUT #update" do
    subject { put :update, update_params }

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses item query " do
      expect_any_instance_of(SectionQuery).to receive(:find).with("1").and_return(section)
      subject
    end

    it "redirects on success" do
      subject

      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "renders new on failure" do
      allow(SaveSection).to receive(:call).and_return(false)

      subject
      expect(response).to render_template("edit")
    end

    it "assigns and section" do
      subject

      expect(assigns(:section)).to eq(section)
    end

    it "uses the save item service" do
      expect(SaveSection).to receive(:call).and_return(true)

      subject
    end

    it_behaves_like "a private content-based etag cacher"
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, id: section.id }

    it "on success, redirects, and flashes " do
      subject
      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "assigns and item" do
      subject

      assigns(:section)
      expect(assigns(:section)).to eq(section)
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses section query " do
      expect_any_instance_of(SectionQuery).to receive(:find).with("1").and_return(section)
      subject
    end

    it "uses the Destroy::Section.cascade method" do
      expect_any_instance_of(Destroy::Section).to receive(:cascade!)
      subject
    end

    it_behaves_like "a private content-based etag cacher"
  end
end
