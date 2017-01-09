# Performs batch creation of items from an array of item hashes.
# Allows injecting a block to change the item attributes before
# attempting to create the item.
class CreateItems
  def self.call(collection:, find_by:, items_hash:, counts:, errors:)
    new.create_or_update!(collection: collection,
                          find_by: find_by,
                          items_hash: items_hash,
                          counts: counts,
                          errors: errors) do |item_props, rewrite_errors|
      if block_given?
        yield(item_props, rewrite_errors)
      else
        item_props
      end
    end
  end

  # Attempts to create/update items given in the items_hash. Increments keys in
  # counts and appends any errors to the given errors array.
  #
  # Entries within the items_hash array are expected to be of format:
  #   { index: index, item_hash: item }
  # where item_hash is the items' new properties, and index will be used when populating errors
  #
  # Count hash keys are defined as:
  #   new_count      - Count of how many new records were created
  #   changed_count  - Count of how many items already existed but were changed
  #   valid_count    - Count of how many items passed validation
  #   error_count    - Count of how many items failed validation
  #   total_count    - Total number of items processed
  def create_or_update!(collection:, find_by:, items_hash:, counts:, errors:)
    items_to_index = []
    ActiveRecord::Base.transaction do
      items_hash.each do |item_props|
        rewrite_errors = []
        index = item_props[:index]
        item_props = yield(item_props[:item_hash], rewrite_errors).symbolize_keys if block_given?
        item_creator = FindOrCreateItem.call(props: { collection_id: collection.id, **item_props }, find_by: find_by)
        saved = rewrite_errors.present? ? false : item_creator.save(index: false)
        add_to_errors(
          errors: errors,
          index: index,
          new_errors: rewrite_errors | item_creator.item.errors.full_messages | item_creator.item.item_metadata.errors.full_messages,
          item: item_creator.item
        )
        items_to_index << item_creator.item if saved && (item_creator.changed? || item_creator.new_record?)
        update_counts(save_successful: saved, item: item_creator, counts: counts)
      end
    end
    Index::Collection.index!(collection: collection, items: items_to_index)
  end

  private

  def add_to_errors(errors:, index:, new_errors:, item:)
    if new_errors.present?
      errors[index] ||= { errors: [], item: item }
      errors[index][:errors] = errors[index][:errors] | new_errors
    end
  end

  def update_counts(save_successful:, item:, counts:)
    counts[:total_count] += 1
    if save_successful
      if item.new_record?
        counts[:new_count] += 1
      else
        if item.changed?
          counts[:changed_count] += 1
        else
          counts[:unchanged_count] += 1
        end
      end
      counts[:valid_count] += 1
    else
      counts[:error_count] += 1
    end
  end
end
