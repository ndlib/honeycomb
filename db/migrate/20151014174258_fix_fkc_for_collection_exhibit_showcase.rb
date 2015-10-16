class FixFkcForCollectionExhibitShowcase < ActiveRecord::Migration
  # Asserts that the given query results are empty
  def empty!(query:, error_message:)
    result = execute query
    if result.count > 0
      raise "Unable to add foreign keys. #{error_message}"
    end
  end

  def up
    empty!(query: "SELECT * FROM showcases WHERE
                     showcases.collection_id IS NULL OR showcases.collection_id NOT IN (SELECT id FROM collections);",
           error_message: "A showcase was found that had no associated collection.")

    add_foreign_key :showcases, :collections
    remove_foreign_key :showcases, :exhibits
  end

  def down
    empty!(query: "SELECT * FROM showcases WHERE
                     showcases.exhibit_id IS NULL OR showcases.exhibit_id NOT IN (SELECT id FROM exhibits);",
           error_message: "Cannot re-add showcase->exhibit constraint. A showcase was found that had no associated exhibit.")

    remove_foreign_key :showcases, :collections
    add_foreign_key :showcases, :exhibits
  end
end
