require "rails_helper"

RSpec.describe V1::ItemsController, :type => :controller do
  let(:collection) { instance_double(Collection, id: "1" ) }
  let(:item) { instance_double(Showcase, id: "1" ) }


  before(:each) do
    allow_any_instance_of(ItemQuery).to receive(:public_find).and_return(item)
    allow_any_instance_of(CollectionQuery).to receive(:public_find).and_return(collection)
  end

  describe "#index" do
    subject { get :index, collection_id: collection.id, format: :json }
    it "calls CollectionQuery" do
      expect_any_instance_of(CollectionQuery).to receive(:public_find).with(collection.id).and_return(collection)

      subject
    end

    it "is successful" do
      subject

      expect(response).to be_success
      expect(assigns(:collection)).to be_present
      expect(subject).to render_template("v1/items/index")
    end
  end

  describe "#show" do
    subject { get :show, id: "id", format: :json }
    it "calls ItemQuery" do
      expect_any_instance_of(ItemQuery).to receive(:public_find).with('id').and_return(item)

      subject
    end

    it "is successful" do
      subject

      expect(response).to be_success
      expect(assigns(:item)).to be_present
      expect(subject).to render_template("v1/items/show")
    end
  end

end
