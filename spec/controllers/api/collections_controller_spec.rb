require "rails_helper"

RSpec.describe API::CollectionsController, :type => :controller do
  let(:collection) { instance_double(Collection, id: 1, title: 'title') }
  let(:collections) { [collection] }

  describe "GET #index" do
    before do
      allow(Collection).to receive(:all).and_return(collections)
    end

    it "errors when json is not requested" do
      expect{get :index}.to raise_error(ActionController::UnknownFormat)
    end

    it "returns json" do
      expect_any_instance_of(CollectionJSON).to receive(:to_hash).and_return({test: 'collection'})
      get :index, format: :json

      expect(response).to be_success
      expect(response.body).to eq("{\"collections\":[{\"test\":\"collection\"}]}")
    end
  end

  describe "GET #show" do
    before(:each) do
      allow(Collection).to receive(:find).and_return(collection)
    end

    it "errors when json is not requested" do
      expect{get :show, id: collection.id}.to raise_error(ActionController::UnknownFormat)
    end

    it "returns json" do
      expect_any_instance_of(CollectionJSON).to receive(:to_hash).and_return({test: 'collection'})
      get :show, id: collection.id, format: :json

      expect(response).to be_success
      expect(response.body).to eq("{\"collections\":{\"test\":\"collection\"}}")
    end
  end
end
