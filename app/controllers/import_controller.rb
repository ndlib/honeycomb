class ImportController < ApplicationController
  # Constructs an auth request to google. Packs the collection id, file, and sheet
  # into state data so that this data persists the round trip.
  # TODO: Move this to client side script if possible to avoid an extra trip
  def get_google_authorization_uri
    session = GoogleSession.new
    authorization_uri = session.auth_request_uri(
      callback_uri: import_google_sheet_callback_collections_url,
      state_hash: {
        collection_id: params[:id],
        file: params[:file_name],
        sheet: params[:sheet_name] }
    )
    render json: { auth_uri: authorization_uri }
  end

  # This should get called whenever google redirects after a successful authorization request.
  # We'll get an authorization code in the params and use this to make the connection
  # to google to read the sheet data
  def import_google_sheet_callback
    state_hash = JSON.parse(Base64::decode64(params[:state]))
    session = GoogleSession.new
    session.connect(auth_code: params[:code], callback_uri: import_google_sheet_callback_collections_url)
    work_sheet = session.get_worksheet(file: state_hash["file"], sheet: state_hash["sheet"])

    # Just as a PoC, print the worksheet data
    if work_sheet.nil?
      render plain: "Worksheet not found."
    else
      render plain: "No data has been imported. This is just a demonstration to show that all your cells are belong to us: #{work_sheet.rows}"
    end
  end
end
