require "rails_helper"

RSpec.describe Api::ItemsController, :type => :controller do
  let(:item) { instance_double(Item, id: 1, title: 'title', collection: collection) }
  let(:items) { [item] }
  let(:collection) { instance_double(Collection, id: 1, title: 'title') }

  before(:each) do
    allow(collection).to receive(:items).and_return(items)
    allow(Collection).to receive(:find).and_return(collection)
  end

  describe "GET #index" do

    it "errors when json is not requested" do
      expect(collection).to receive(:items).and_return(Item.all)
      expect{get :index, collection_id: collection.id}.to raise_error(ActionController::UnknownFormat)
    end

    it "returns json" do
      expect_any_instance_of(ItemJson).to receive(:to_hash).and_return({item: 'item'})
      get :index, collection_id: collection.id, format: :json

      expect(response).to be_success
      expect(response.body).to eq("{\"items\":[{\"item\":\"item\"}]}")
    end
  end

  describe "GET #show" do
    before do
      allow(items).to receive(:find).and_return(item)
    end

    it "errors when json is not requested" do
      expect(items).to receive(:find).and_return(item)
      expect{get :show, collection_id: collection.id, id: item.id}.to raise_error(ActionController::UnknownFormat)
    end

    it "returns json" do
      expect_any_instance_of(ItemJson).to receive(:to_hash).and_return({item: 'item'})
      get :show, collection_id: collection.id, id: item.id, format: :json

      expect(response).to be_success
      expect(response.body).to eq("{\"items\":{\"item\":\"item\"}}")
    end
  end
end
