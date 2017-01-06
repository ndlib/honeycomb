require "google/api_client"
require "google_drive"

class GoogleSession
  attr_reader :auth, :session

  # rubocop:disable Metrics/AbcSize
  # All options to simplify this either make it less readable or
  # go against our convention of using attr readers
  def initialize(client: nil)
    client = client || Google::APIClient.new
    @auth = client.authorization
    auth.client_id = Rails.application.secrets.google["client_id"]
    auth.client_secret = Rails.application.secrets.google["client_secret"]
    auth.scope = ["https://www.googleapis.com/auth/drive.file"]
  end
  # rubocop:enable Metrics/AbcSize

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

  # Returns an array of hashes where the hash keys are the column names
  # Worksheet must have a header row to use as keys in the hash. Blank cells will
  # be ignored except in the case of the Identifier or Parent Identifier columns
  def worksheet_to_hash(worksheet:)
    results = []
    rows = worksheet.rows
    if rows.present?
      header_row = rows[0]
      results = rows[1..rows.size].map do |row|
        hash = Hash.new
        row.each_with_index do |cell, cell_index|
          header = header_row[cell_index]
          if header == "Identifier" || header == "Parent Identifier" || cell.present?
            hash[header] = cell.presence
          end
        end
        hash
      end
    end
    results
  end

  # Populates a worksheet with an array of hashes where the hash keys are
  # used as the column names
  def hashes_to_worksheet(worksheet:, hashes:)
    header_row = []
    rows = [header_row]
    hashes.each do |hash|
      # See if this hash has any new columns. If so, append it to the end
      hash.keys.each do |key|
        unless header_row.include?(key)
          header_row << key
        end
      end

      # Populate the row with values based on the order of the header row
      row = []
      header_row.each do |header|
        if hash.include?(header)
          row << hash[header]
        else
          row << ""
        end
      end
      rows << row
    end
    rows[0] = header_row
    rows_per_batch = Rails.configuration.settings.export_batch_size || rows.count
    row_batches = rows.in_groups_of(rows_per_batch, false)

    row_batches.each.with_index do |row_batch, i|
      worksheet.update_cells(1 + (i * rows_per_batch), 1, row_batch)
      worksheet.save
    end
  end
end
