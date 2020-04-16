require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::FacetsController, type: :controller do
  let(:collection) { instance_double(Collection, id: 1) }
  let(:configuration) { double(Metadata::Configuration) }

  before(:each) do
    allow_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
    @user = sign_in_admin
  end

  describe "update" do
    let(:params) { { label: "name" } }
    subject { put :update, collection_id: 1, id: "id", facets: params, format: :json }

    before(:each) do
      allow(Metadata::UpdateConfigurationFacet).to receive(:call).and_return(true)
    end

    it "queries for the collection" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
      subject
    end

    it "calls Metadata::UpdateConfigurationFacet with an empty hash even if there are no params in order to perform validation" do
      expect(Metadata::UpdateConfigurationFacet).to receive(:call).with(collection, "id", {}).and_return(true)
      put :update, collection_id: 1, id: "id", format: :json
    end

    it "uses the Metadata::UpdateConfigurationFacet to update the data" do
      expect(Metadata::UpdateConfigurationFacet).to receive(:call).with(collection, "id", params)
      subject
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:user_can_edit?).with(collection)
      subject
    end
  end

  describe "create" do
    let(:params) { { label: "name" } }
    subject { post :create, collection_id: 1, facets: params, format: :json }

    before(:each) do
      allow(Metadata::CreateConfigurationFacet).to receive(:call).and_return(true)
    end

    it "queries for the collection" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
      subject
    end

    it "calls Metadata::CreateConfigurationFacet with an empty hash even if there are no params in order to perform validation" do
      expect(Metadata::CreateConfigurationFacet).to receive(:call).with(collection, {}).and_return(true)
      post :create, collection_id: 1, id: "id", format: :json
    end

    it "uses the Metadata::CreateConfigurationFacet to update the data" do
      expect(Metadata::CreateConfigurationFacet).to receive(:call).with(collection, params)
      subject
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:user_can_edit?).with(collection)
      subject
    end

    it "renders success if the save succeeds" do
      subject
      expect(response.status).to eq(200)
    end

    it "renders the new facet in the json response if the save succeeds" do
      subject
      expect(JSON.parse(response.body)).to include("facet" => true)
    end

    it "returns unprocessable entity if the save fails" do
      allow(Metadata::CreateConfigurationFacet).to receive(:call).with(collection, params).and_return(false)
      subject
      expect(response.status).to eq(422)
    end

    it "returns the facet params in the json response if the save fails" do
      allow(Metadata::CreateConfigurationFacet).to receive(:call).with(collection, params).and_return(false)
      subject
      expect(JSON.parse(response.body)).to include("facet" => params.stringify_keys)
    end
  end

  describe "destroy" do
    let(:id) { "name" }
    subject { delete :destroy, collection_id: 1, id: id, format: :json }

    before(:each) do
      allow(Metadata::RemoveConfigurationFacet).to receive(:call).and_return(true)
    end

    it "queries for the collection" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
      subject
    end

    it "uses the Metadata::RemoveConfigurationFacet to delete the facet" do
      expect(Metadata::RemoveConfigurationFacet).to receive(:call).with(collection, id)
      subject
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:user_can_edit?).with(collection)
      subject
    end

    it "renders success if the save succeeds" do
      subject
      expect(response.status).to eq(200)
    end

    it "renders success in the json response if the remove succeeds" do
      subject
      expect(JSON.parse(response.body)).to include("success" => true)
    end

    it "returns unprocessable entity if the remove fails" do
      allow(Metadata::RemoveConfigurationFacet).to receive(:call).with(collection, id).and_return(false)
      subject
      expect(response.status).to eq(422)
    end

    it "returns the facet params in the json response if the remove fails" do
      allow(Metadata::RemoveConfigurationFacet).to receive(:call).with(collection, id).and_return(false)
      subject
      expect(JSON.parse(response.body)).to include("id" => id)
    end
  end

  describe "reorder" do
    let(:params) { { "0" => { facet: "name", order: 1 } } }
    subject { put :reorder, collection_id: 1, facets: params, format: :json }

    before(:each) do
      allow(ReorderFacets).to receive(:call).and_return(true)
    end

    it "queries for the collection" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
      subject
    end

    it "calls Metadata::UpdateConfigurationFacet with an empty hash even if there are no params in order to perform validation" do
      expect(ReorderFacets).to receive(:call).with(collection, params).and_return(true)
      put :reorder, collection_id: 1, facets: params, format: :json
    end

    it "uses the Metadata::UpdateConfigurationFacet to update the data" do
      expect(ReorderFacets).to receive(:call).with(collection, params)
      subject
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:user_can_edit?).with(collection)
      subject
    end
  end
end
