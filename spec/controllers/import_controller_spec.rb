require "rails_helper"
require "cache_spec_helper"

RSpec.describe ImportController, type: :controller do
  before(:each) do
    @user = sign_in_admin
  end

  describe "get_authorization_uri" do
    let(:state_hash) { { collection_id: "1", file: "test.file", sheet: "test.sheet" } }
    let(:param_hash) { { state_hash: state_hash } }

    it "uses google api to request an auth uri" do
      expect_any_instance_of(GoogleSession).to receive(:auth_request_uri).with(hash_including(param_hash))
      post :get_google_authorization_uri, id: 1, file_name: state_hash[:file], sheet_name: state_hash[:sheet]
    end

    it "renders a json with the auth_uri" do
      get :get_google_authorization_uri, id: 1, file_name: "test.file", sheet_name: "test.sheet"
      expect(JSON.parse(response.body)).to include("auth_uri")
    end
  end

  describe "import_google_sheet_callback" do
    let(:state_hash) { { collection_id: "1", file: "test.file", sheet: "test.sheet" } }
    let(:encoded_state_hash) { Base64::encode64(state_hash.to_json) }
    let(:worksheet) { instance_double(GoogleDrive::Worksheet, rows: []) }

    it "uses google api to retrieve the worksheet" do
      allow_any_instance_of(GoogleSession).to receive(:connect)
      expect_any_instance_of(GoogleSession).to receive(:get_worksheet).with(file: state_hash[:file], sheet: state_hash[:sheet]).and_return(nil)
      get :import_google_sheet_callback, state: encoded_state_hash
    end

    it "gets the rows of the worksheet" do
      allow_any_instance_of(GoogleSession).to receive(:connect)
      allow_any_instance_of(GoogleSession).to receive(:get_worksheet).and_return(worksheet)
      expect(worksheet).to receive(:rows)
      get :import_google_sheet_callback, state: encoded_state_hash
    end
  end
end
