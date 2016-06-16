require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::MetadataController, type: :controller do
  before(:each) do
    allow_any_instance_of(ItemQuery).to receive(:public_find).and_return(item)
    allow_any_instance_of(CollectionQuery).to receive(:public_find).and_return(collection)
  end

  describe "PUT #update" do
    let(:collection_configuration) { CollectionConfiguration.new }
    let(:collection) { double(Collection, id: "1", collection_configuration: collection_configuration) }
    let(:item) { instance_double(Item, id: 1, parent: nil, collection: collection, item_metadata: double(valid?: true), metadata: {}) }
    let(:update_params) { { format: :json, item_id: item.id, metadata: { name: "item" } } }
    let(:base_config) do
      c = CreateCollectionConfiguration.new("")
      c.send(:base_config)
    end
    subject { put :update, update_params }

    before(:each) do
      sign_in_admin
      allow(SaveMetadata).to receive(:call).and_return(true)
      allow_any_instance_of(ItemQuery).to receive(:find).and_return(item)
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:user_can_edit?).with(collection)
      subject
    end

    it "uses item query " do
      expect_any_instance_of(ItemQuery).to receive(:public_find).with("1").and_return(item)
      subject
    end

    it "returns ok on success" do
      subject
      expect(response).to be_success
    end

    it "renders the item only on success" do
      subject
      expect(response).to render_template("update")
    end

    it "returns unprocessable on failure" do
      allow(SaveMetadata).to receive(:call).and_return(false)
      subject
      expect(response).to be_unprocessable
    end

    it "renders with errors" do
      allow(SaveMetadata).to receive(:call).and_return(false)
      subject
      expect(response).to render_template("errors")
    end

    it "assigns an item" do
      subject

      assigns(:item)
      expect(assigns(:item)).to eq(item)
    end

    it "uses the save metadata service" do
      expect(SaveMetadata).to receive(:call).and_return(true)

      subject
    end
  end
end
