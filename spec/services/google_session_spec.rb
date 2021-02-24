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
                    "access_token" => nil,
                    "access_token=" => nil)
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
      allow(GoogleDrive::Session).to receive(:new).and_return("session")
      expect(auth).to receive(:fetch_access_token!)
      subject.connect(auth_code: "auth_code", callback_uri: "callback_uri")
    end

    it "makes a login request with GoogleDrive" do
      expect(GoogleDrive::Session).to receive(:new)
      subject.connect(auth_code: "auth_code", callback_uri: "callback_uri")
    end

    it "sets the session" do
      allow(GoogleDrive::Session).to receive(:new).and_return("session")
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
        ["Identifier", "Name", "Alternate Name", "Description", "Date Created", "Creator", "Subject", "Original Language", "Parent Identifier"],
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

    it "returns an empty array if there aren't any rows in the worksheet" do
      allow(worksheet).to receive(:rows).and_return([])
      result = subject.worksheet_to_hash(worksheet: worksheet)
      expect(result).to eq([])
    end

    it "does not return a property if the column has no value" do
      rows[1][3] = nil
      items[0].delete("Description")
      result = subject.worksheet_to_hash(worksheet: worksheet)
      expect(result).to eq(items)
    end

    it "returns Parent Identifier even if the column has no value" do
      rows[1][8] = nil
      rows[2][8] = nil
      rows[3][8] = nil
      results = subject.worksheet_to_hash(worksheet: worksheet)
      results.each do |result|
        expect(result).to include("Parent Identifier" => nil)
      end
    end

    it "returns Identifier even if the column has no value" do
      rows[1][0] = nil
      rows[2][0] = nil
      rows[3][0] = nil
      results = subject.worksheet_to_hash(worksheet: worksheet)
      results.each do |result|
        expect(result).to include("Identifier" => nil)
      end
    end
  end

  describe "hashes to worksheet", helpers: :item_meta_helpers do
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
    let(:worksheet) { instance_double(GoogleDrive::Worksheet, rows: rows, save: true) }

    it "updates the cells then saves the worksheet" do
      expect(worksheet).to receive(:update_cells).ordered
      expect(worksheet).to receive(:save).ordered
      subject.hashes_to_worksheet(worksheet: worksheet, hashes: items)
    end

    it "converts objects to 2d array with first row as header for all object fields" do
      expect(worksheet).to receive(:update_cells).with(1, 1, rows)
      subject.hashes_to_worksheet(worksheet: worksheet, hashes: items)
    end

    it "handles non uniform columns" do
      items = [
        {
          "Identifier" => "id1",
          "Name" => "name1",
          "Alternate Name" => "alternateName1",
          "Description" => "description1",
          "Date Created" => "2015/01/01",
          "Creator" => "creator1",
          "Subject" => "subject1",
          "Language" => "originalLanguage1",
          "Other Column" => "someValue1"
        },
        {
          "Identifier" => "id2",
          "Name" => "name2",
          "Alternate Name" => "alternateName2",
          "Description" => "description2",
          "Date Created" => "2015/01/01",
          "Subject" => "subject2",
          "Language" => "originalLanguage2"
        },
        {
          "Identifier" => "id3",
          "Name" => "name3",
          "Description" => "description3",
          "Date Created" => "2015/01/01",
          "New Column" => "newColumn3",
          "Creator" => "creator3",
          "Subject" => "subject3",
          "Language" => "originalLanguage3",
        }
      ]
      expected = [["Identifier", "Name", "Alternate Name", "Description", "Date Created", "Creator", "Subject", "Language", "Other Column", "New Column"]]
      expected << ["id1", "name1", "alternateName1", "description1", "2015/01/01", "creator1", "subject1", "originalLanguage1", "someValue1"]
      expected << ["id2", "name2", "alternateName2", "description2", "2015/01/01", "", "subject2", "originalLanguage2", ""]
      expected << ["id3", "name3", "", "description3", "2015/01/01", "creator3", "subject3", "originalLanguage3", "", "newColumn3"]
      expect(worksheet).to receive(:update_cells).with(1, 1, expected)
      subject.hashes_to_worksheet(worksheet: worksheet, hashes: items)
    end
  end
end
