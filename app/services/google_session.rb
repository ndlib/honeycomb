require "google/api_client"
require "google_drive"

class GoogleSession
  attr_reader :auth, :session

  def initialize(client: nil)
    client = client || Google::APIClient.new
    @auth = client.authorization
    auth.client_id = Rails.application.secrets.google["client_id"]
    auth.client_secret = Rails.application.secrets.google["client_secret"]
    auth.scope = ["https://www.googleapis.com/auth/drive.file"]
  end

  # Creates an authorization request uri to send to google
  def auth_request_uri(state_hash:, callback_uri:)
    auth.state = Base64.encode64(state_hash.to_json)
    auth.redirect_uri = callback_uri
    auth.authorization_uri(hd: "nd.edu").to_s
  end

  # Establishes a connection with google. auth_code must be
  # the code returned by google after submitting a successful
  # request to auth_request_uri
  def connect(auth_code:, callback_uri:)
    auth.redirect_uri = callback_uri
    auth.code = auth_code
    auth.fetch_access_token!
    @session = GoogleDrive.login_with_oauth(auth.access_token)
  end

  # Gets a worksheet at the given file url
  # Assumes connect has been successfully called
  def get_worksheet(file:, sheet:)
    spread_sheet = session.file_by_url(file)
    if sheet.present?
      spread_sheet.worksheet_by_title(sheet)
    else
      spread_sheet.worksheets[0]
    end
  end
end
