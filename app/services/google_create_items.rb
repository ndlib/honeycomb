# Performs batch creation of items from a google doc
# Assumes you have a valid auth token to access the doc
class GoogleCreateItems
  attr_reader :session

  # Simplified call to create_from_worksheet!
  def self.call(auth_code:, callback_uri:, collection_id:, file:, sheet:)
    instance = new(auth_code: auth_code, callback_uri: callback_uri)
    instance.create_from_worksheet!(collection_id: collection_id, file: file, sheet: sheet)
  end

  def initialize(auth_code:, callback_uri:)
    @session = GoogleSession.new
    session.connect(auth_code: auth_code, callback_uri: callback_uri)
  end

  # Adds new items to a collection for each row in a google spread sheet
  def create_from_worksheet!(collection_id:, file:, sheet:)
    counts = {
      total_count: 0,
      valid_count: 0,
      new_count: 0,
      error_count: 0,
      changed_count: 0,
      unchanged_count: 0
    }
    errors = {}

    worksheet = session.get_worksheet(file: file, sheet: sheet)
    if worksheet.present?
      items = session.worksheet_to_hash(worksheet: worksheet)

      CreateItems.call(collection_id: collection_id,
                       find_by: [:collection_id, :user_defined_id],
                       items_hash: items,
                       counts: counts,
                       errors: errors) do |item_props, rewrite_errors|
        RewriteItemMetadata.call(item_hash: item_props, errors: rewrite_errors, configuration: configuration(collection_id))
      end
    end
    {
      summary: counts,
      errors: errors
    }
  end

  private

  def configuration(collection_id)
    @configuration ||= CollectionConfigurationQuery.new(CollectionQuery.new.find(collection_id)).find
  end
end
