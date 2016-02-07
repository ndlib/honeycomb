require "rails_helper"
require "cache_spec_helper"

RSpec.describe ItemChildrenController, type: :controller do
  let(:parent) { instance_double(Item, id: 1, children: Item.all, collection: collection) }

  let(:collection) { instance_double(Collection, id: 1) }
  let(:relation) { Item.all }
  let(:create_params) { { collection_id: collection.id, item_id: parent.id, item: { name: "name" } } }

  before(:each) do
    allow_any_instance_of(ItemQuery).to receive(:find).and_return(parent)

    sign_in_admin
  end

  describe "GET #new" do
    subject {  get :new, item_id: parent.id }

    it "returns a 200" do
      subject

      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template("new")
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses item query " do
      expect_any_instance_of(ItemQuery).to receive(:build).and_return(Item.new)
      subject
    end

    it "assigns and item and it is an item decorator" do
      subject

      assigns(:item)
      expect(assigns(:item)).to be_a(Item)
    end

    it_behaves_like "a private content-based etag cacher"
  end

  describe "POST #create" do
    subject { post :create, create_params }

    before(:each) do
      allow(SaveItem).to receive(:call).and_return(true)
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses item query " do
      expect_any_instance_of(ItemQuery).to receive(:build).and_return(Item.new)
      subject
    end

    it "redirects on success" do
      subject

      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "renders new on failure" do
      allow(SaveItem).to receive(:call).and_return(false)

      subject
      expect(response).to render_template("new")
    end

    it "assigns and item" do
      subject

      assigns(:item)
      expect(assigns(:item)).to be_a(Item)
    end

    it "uses the save item service" do
      expect(SaveItem).to receive(:call).and_return(true)

      subject
    end

    it_behaves_like "a private content-based etag cacher"
  end
end
