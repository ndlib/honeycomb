require "rails_helper"
require "cache_spec_helper"

RSpec.describe API::ItemsController, type: :controller do
  let(:item) { instance_double(Item, id: 1, name: "name", collection: collection) }
  let(:items) { [item] }
  let(:collection) { instance_double(Collection, id: 1, name_line_1: "name_line_1") }

  before(:each) do
    allow(collection).to receive(:items).and_return(items)
    allow(Collection).to receive(:find).and_return(collection)
  end

  describe "GET #index" do
    it "errors when json is not requested" do
      expect(collection).to receive(:items).and_return(Item.all)
      expect { get :index, collection_id: collection.id }.to raise_error(ActionController::UnknownFormat)
    end

    it "returns json" do
      expect(collection).to receive(:items).and_return(Item.all)
      get :index, collection_id: collection.id, format: :json

      expect(response).to be_success
      expect(response.body).to eq("{\"items\":[]}")
      expect(assigns(:collection)).to be_present
    end

    it_behaves_like "a private content-based etag cacher" do
      before do
        allow(collection).to receive(:items).and_return(Item.all)
      end
      subject { get :index, collection_id: collection.id, format: :json }
    end
  end

  describe "GET #show" do
    before do
      allow(items).to receive(:find).and_return(item)
    end

    it "errors when json is not requested" do
      expect(items).to receive(:find).and_return(item)
      expect { get :show, collection_id: collection.id, id: item.id }.to raise_error(ActionController::UnknownFormat)
    end

    it "returns json" do
      expect_any_instance_of(ItemJSON).to receive(:to_hash).and_return(item: "item")
      get :show, collection_id: collection.id, id: item.id, format: :json

      expect(response).to be_success
      expect(response.body).to eq("{\"items\":{\"item\":\"item\"}}")
      expect(assigns(:item)).to be_present
    end

    it_behaves_like "a private content-based etag cacher" do
      before do
        allow_any_instance_of(ItemJSON).to receive(:to_hash).and_return(item: "item")
      end
      subject { get :show, collection_id: collection.id, id: item.id, format: :json }
    end
  end
end
