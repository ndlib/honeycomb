require "rails_helper"
require "cache_spec_helper"

RSpec.describe ImportController, type: :controller do
  let(:collection) { instance_double(Collection, id: 1, name_line_1: "COLLECTION", destroy!: true, collection_users: [], items: []) }

  before(:each) do
    @user = sign_in_admin
    allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
  end

  describe "get_authorization_uri" do
    let(:state_hash) { { collection_id: "1", file: "test.file", sheet: "test.sheet" } }
    let(:param_hash) { { callback_uri: import_google_sheet_callback_collections_url, state_hash: state_hash } }

    it "uses google api to request an auth uri" do
      expect_any_instance_of(GoogleSession).to receive(:auth_request_uri).with(hash_including(param_hash))
      post :get_google_import_authorization_uri, id: 1, file_name: state_hash[:file], sheet_name: state_hash[:sheet]
    end

    it "renders a json with the auth_uri" do
      get :get_google_import_authorization_uri, id: 1, file_name: "test.file", sheet_name: "test.sheet"
      expect(JSON.parse(response.body)).to include("auth_uri")
    end
  end

  describe "import_google_sheet_callback" do
    let(:state_hash) { { collection_id: "1", file: "test.file", sheet: "test.sheet" } }
    let(:param_hash) { { auth_code: "auth", callback_uri: import_google_sheet_callback_collections_url } }
    let(:encoded_state_hash) { Base64::encode64(state_hash.to_json) }
    let(:subject) { get :import_google_sheet_callback, state: encoded_state_hash, code: "auth" }

    it "calls GoogleCreateItems using the given params" do
      expect(GoogleCreateItems).to receive(:call).with(hash_including(param_hash))
      subject
    end

    it "checks the editor permissions" do
      allow(GoogleCreateItems).to receive(:call).with(hash_including(param_hash))
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end
  end

  describe "decode_state" do
    let(:state_hash) { { collection_id: "1", file: "test.file", sheet: "test.sheet" } }
    let(:param_hash) { { auth_code: "auth", callback_uri: import_google_sheet_callback_collections_url } }
    let(:encoded_state_hash) { Base64::encode64(state_hash.to_json) }
    let(:subject) { ImportController.new }

    it "properly decodes the state" do
      expect(subject.decode_state(state_hash: encoded_state_hash)).to eq(state_hash)
    end
  end
end
