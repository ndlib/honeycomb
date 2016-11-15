require 'csv'
# Performs batch creation of items from a csv file
# Assumes you have a valid auth token to access the doc
class CsvCreateItems
  attr_reader :configuration, :collection

  # Simplified call to create_from_worksheet!
  def self.call(collection:, file:)
    new(collection: collection, file: file).create!
  end

  def initialize(collection:, file:)
    @collection = collection
    @file = file
  end

  # Adds new items to a collection for each row in a google spread sheet
  def create!
    counts = {
      total_count: 0,
      valid_count: 0,
      new_count: 0,
      error_count: 0,
      changed_count: 0,
      unchanged_count: 0
    }
    errors = {}
    file = File.read(@file.path)
    if file.valid_encoding?
      items = csv_to_hash(file: file)
      CreateItems.call(collection: @collection,
                       find_by: [:collection_id, :user_defined_id],
                       items_hash: items,
                       counts: counts,
                       errors: errors) do |item_props, rewrite_errors|
        RewriteItemMetadata.call(item_hash: item_props, errors: rewrite_errors, configuration: collection_configuration)
      end
    else
      errors = "File must be UTF-8."
    end

    {
      summary: counts,
      errors: errors
    }
  end

  def csv_to_hash(file:)
    results = []
    csv = CSV.parse(file, headers: true)
    csv.each do |row|
      results << row.to_hash
    end
    results
  end

  private

  def collection_configuration
    @configuration ||= CollectionConfigurationQuery.new(@collection).find
  end
end
