class ImportController < ApplicationController
  # Constructs an auth request to google. Packs the collection id, file, and sheet
  # into state data so that this data persists the round trip.
  def get_google_import_authorization_uri
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
    state_hash = decode_state(state_hash: params[:state])
    @collection = CollectionQuery.new.find(state_hash[:collection_id])
    check_user_edits!(@collection)
    set_configuration(@collection)

    @results = GoogleCreateItems.call(auth_code: params[:code],
                                      callback_uri: import_google_sheet_callback_collections_url,
                                      collection_id: state_hash[:collection_id],
                                      file: state_hash[:file],
                                      sheet: state_hash[:sheet])
  end

  def decode_state(state_hash:)
    JSON.parse(Base64::decode64(state_hash), symbolize_names: true)
  end

  private

  def set_configuration(collection)
    Waggle.set_configuration(CollectionConfigurationQuery.new(collection).find)
  end
end
