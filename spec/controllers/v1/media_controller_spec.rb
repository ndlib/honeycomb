require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::MediaController, type: :controller do
  context "for items" do
    let(:collection) { instance_double(Collection, id: "1") }
    let(:item) { instance_double(Item, id: "1", collection: collection) }
    let(:media) do
      instance_double(Media,
                      id: "1",
                      updated_at: nil,
                      valid?: true,
                      save: true,
                      to_json: "media 1 json",
                      collection: collection)
    end

    describe "create" do
      let(:params) { { item_id: "item_id", format: :json, medium: { file_name: "filename.ext" } } }
      subject { post :create_for_item, params }

      before(:each) do
        sign_in_admin
        allow_any_instance_of(ItemQuery).to receive(:public_find).and_return(item)
      end

      it "uses the CreateMedia service" do
        expect(CreateMedia).to receive(:call).with(owner: item, collection: collection, params: params[:medium]).and_return(media)
        subject
      end

      it "renders 200 when media is valid" do
        allow(CreateMedia).to receive(:call).with(owner: item, collection: collection, params: params[:medium]).and_return(media)
        subject
        expect(response.status).to eq(200)
      end

      it "renders the media as json when media is valid" do
        allow(CreateMedia).to receive(:call).with(owner: item, collection: collection, params: params[:medium]).and_return(media)
        subject
        expect(response.body).to eq("media 1 json")
      end

      it "renders 422 when media is invalid" do
        allow(media).to receive(:valid?).and_return(false)
        allow(CreateMedia).to receive(:call).with(owner: item, collection: collection, params: params[:medium]).and_return(media)
        subject
        expect(response.status).to eq(422)
      end
    end
  end

  context "finish upload" do
    let(:collection) { instance_double(Collection, id: "1") }
    let(:media) do
      instance_double(Media,
                      id: "1",
                      updated_at: nil,
                      valid?: true,
                      save: true,
                      to_json: "media 1 json",
                      collection: collection)
    end
    subject { put :finish_upload, medium_id: media.id }

    describe "finish_upload" do
      before(:each) do
        sign_in_admin
        allow_any_instance_of(MediaQuery).to receive(:public_find).with(media.id).and_return(media)
      end

      it "uses the FinishMediaUpload service" do
        expect(FinishMediaUpload).to receive(:call).with(media: media).and_return(media)
        subject
      end

      it "renders 200 when media is valid" do
        allow(FinishMediaUpload).to receive(:call).with(media: media).and_return(media)
        subject
        expect(response.status).to eq(200)
      end

      it "renders the media as json when media is valid" do
        allow(FinishMediaUpload).to receive(:call).with(media: media).and_return(media)
        subject
        expect(response.body).to eq("media 1 json")
      end

      it "renders 422 when media is invalid" do
        allow(media).to receive(:valid?).and_return(false)
        allow(FinishMediaUpload).to receive(:call).with(media: media).and_return(media)
        subject
        expect(response.status).to eq(422)
      end
    end
  end
end
