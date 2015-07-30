require "google/api_client"
require "google_drive"

class GoogleSession
  attr_reader :auth, :collection

  def self.call(collection:)
    new(collection: collection).auth_request
  end

  def initialize(collection:)
    @collection = collection
  end

  def auth_request
    # Authorizes with OAuth and gets an access token.
    client = Google::APIClient.new
    @auth = client.authorization
    auth.client_id = "748893423292-tg07o0g66celmnk06ned9o5vmp0jdiqc.apps.googleusercontent.com"
    auth.client_secret = "P4CfZzgeWp7kUALb3Q69ulW0"
    auth.scope = [
      "https://www.googleapis.com/auth/drive",
      "https://spreadsheets.google.com/feeds/"
    ]
    auth.state = Base64.encode64( "{ \"collection\": \"#{@collection.id}\", \"filename\": \"https://docs.google.com/spreadsheets/d/1nIh8eEDtd9yrJxF8i_Np4fB46RFH8UW4nuevifI1mos/edit#gid=0\" }")
    auth.redirect_uri = "http://localhost:3017/collections/oauth2callback"
    self
  end

  def create_sesssion(auth_code:)
    auth.code = auth_code
    auth.fetch_access_token!
    GoogleDrive.login_with_oauth(auth.access_token)
  end
end
