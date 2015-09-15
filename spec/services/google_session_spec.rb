require "rails_helper"
require "support/item_meta_helpers"

RSpec.configure do |c|
  c.include ItemMetaHelpers, helpers: :item_meta_helpers
end

RSpec.describe GoogleSession do
  let(:client) { instance_double(Google::APIClient, authorization: auth) }
  let(:auth) do
    instance_double(Signet::OAuth2::Client,
                    "client_id=" => nil,
                    "client_secret=" => nil,
                    "scope=" => nil,
                    "state=" => nil,
                    "redirect_uri=" => nil,
                    "authorization_uri" => nil,
                    "code=" => nil,
                    "fetch_access_token!" => nil,
                    "access_token" => nil)
  end
  let(:subject) { GoogleSession.new(client: client) }

  it "only uses the file scope" do
    expect(auth).to receive("scope=").with(array_including("https://www.googleapis.com/auth/drive.file"))
    subject
  end

  describe "auth_request_uri" do
    let(:state_hash) { { collection_id: "1", file: "test.file", sheet: "test.sheet" } }

    it "encodes the state hash" do
      expect(auth).to receive("state=").with(Base64.encode64(state_hash.to_json))
      subject.auth_request_uri(state_hash: state_hash, callback_uri: "")
    end

    it "limits to nd.edu domain" do
      expect(auth).to receive("authorization_uri").with(hd: "nd.edu")
      subject.auth_request_uri(state_hash: state_hash, callback_uri: "")
    end
  end

  describe "connect" do
    it "requests an access token" do
      expect(auth).to receive(:fetch_access_token!)
      subject.connect(auth_code: "auth_code", callback_uri: "callback_uri")
    end

    it "makes a login request with GoogleDrive" do
      expect(GoogleDrive).to receive(:login_with_oauth)
      subject.connect(auth_code: "auth_code", callback_uri: "callback_uri")
    end

    it "sets the session" do
      allow(GoogleDrive).to receive(:login_with_oauth).and_return("session")
      subject.connect(auth_code: "auth_code", callback_uri: "callback_uri")
      expect(subject.session).to eq("session")
    end
  end

  describe "get_worksheet" do
    let(:session) { instance_double(GoogleDrive::Session, file_by_url: file) }
    let(:file) do
      instance_double(GoogleDrive::Spreadsheet,
                      present?: false,
                      worksheet_by_title: "worksheet_by_title",
                      worksheets: ["worksheet0", "worksheet1"])
    end

    before(:each) do
      allow(subject).to receive(:session).and_return(session)
    end

    it "gets the first worksheet if none is specified" do
      worksheet = subject.get_worksheet(file: "", sheet: "")
      expect(worksheet).to eq("worksheet0")
    end

    it "gets the worksheet specified" do
      worksheet = subject.get_worksheet(file: "", sheet: "sheet")
      expect(worksheet).to eq("worksheet_by_title")
    end
  end

  describe "worksheet_to_hash", helpers: :item_meta_helpers do
    let(:rows) do
      [
        ["Identifier", "Name", "Alternate Name", "Description", "Date Created", "Creator", "Subject", "Original Language"],
        item_meta_array(item_id: 1),
        item_meta_array(item_id: 2),
        item_meta_array(item_id: 3)
      ]
    end
    let(:items) do
      [
        item_meta_hash(item_id: 1),
        item_meta_hash(item_id: 2),
        item_meta_hash(item_id: 3),
      ]
    end
    let(:worksheet) { instance_double(GoogleDrive::Worksheet, rows: rows) }

    it "converts to array of item hashes" do
      result = subject.worksheet_to_hash(worksheet: worksheet)
      expect(result).to eq(items)
    end

    it "does not return a property if the column has no value" do
      rows[1][3] = nil
      items[0].delete("Description")
      result = subject.worksheet_to_hash(worksheet: worksheet)
      expect(result).to eq(items)
    end
  end
end
