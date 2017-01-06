# Performs batch creation of items from a google doc
# Assumes you have a valid auth token to access the doc
class GoogleCreateItems
  attr_reader :session

  # Simplified call to create_from_worksheet!
  def self.call(auth_code:, callback_uri:, collection:, file:, sheet:)
    instance = new(auth_code: auth_code, callback_uri: callback_uri)
    instance.create_from_worksheet!(collection: collection, file: file, sheet: sheet)
  end

  def initialize(auth_code:, callback_uri:)
    @session = GoogleSession.new
    session.connect(auth_code: auth_code, callback_uri: callback_uri)
  end

  # Adds new items to a collection for each row in a google spread sheet
  def create_from_worksheet!(collection:, file:, sheet:)
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
      parents_then_children(items: items).each do |items_hash|
        CreateItems.call(collection: collection,
                         find_by: [:collection_id, :user_defined_id],
                         items_hash: items_hash,
                         counts: counts,
                         errors: errors) do |item_props, rewrite_errors|
          RewriteItemMetadata.call(item_hash: item_props, errors: rewrite_errors, configuration: configuration(collection))
        end
      end
    end
    {
      summary: counts,
      errors: errors
    }
  end

  private

  def parents_then_children(items:)
    parents = []
    children = []
    items.each.with_index do |item, index|
      if item["Parent Identifier"].present?
        parents << { original_index: index, item_hash: item }
      else
        children << { original_index: index, item_hash: item }
      end
    end
    [parents, children]
  end

  def configuration(collection)
    @configuration ||= CollectionConfigurationQuery.new(collection).find
  end
end
