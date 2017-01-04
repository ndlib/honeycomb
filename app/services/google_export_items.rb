# Performs batch export of items to a google doc
# Assumes you have a valid auth token to access the doc
class GoogleExportItems
  attr_reader :session

  # Simplified call to create_from_worksheet!
  def self.call(auth_code:, callback_uri:, items:, file:, sheet:)
    instance = new(auth_code: auth_code, callback_uri: callback_uri)
    instance.export_to_worksheet!(items: items, file: file, sheet: sheet)
  end

  def initialize(auth_code:, callback_uri:)
    @session = GoogleSession.new
    session.connect(auth_code: auth_code, callback_uri: callback_uri)
  end

  def export_to_worksheet!(items:, file:, sheet:)
    worksheet = session.get_worksheet(file: file, sheet: sheet)
    if worksheet.present?
      item_hashes = items.map do |item|
        parent_user_defined_id = item.parent ? item.parent.user_defined_id : nil
        meta_hash = RewriteItemMetadataForExport.call(user_defined_id: item.user_defined_id,
                                                      parent_user_defined_id: parent_user_defined_id,
                                                      item_hash: item.metadata,
                                                      configuration: configuration(item.collection))
        # Prefix all values with ' to force google to treat all values as text, otherwise it will reformat things like dates/numbers
        # and cause problems on import
        meta_hash.each { |k, v| meta_hash[k] = "'" + v unless v.nil? }
      end
      session.hashes_to_worksheet(worksheet: worksheet, hashes: item_hashes)
    end
  end

  private

  def configuration(collection)
    @configuration ||= CollectionConfigurationQuery.new(collection).find
  end
end
