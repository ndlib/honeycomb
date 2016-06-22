module Brood
  class Collection
    attr_reader :base_path, :item_count

    def initialize(base_path)
      @base_path = base_path
      @item_count = 0
    end

    def data
      @data ||= JSON.parse(File.read(path("data.json")))
    end

    def collection_data
      data["collection"]
    end

    def items_data
      data["items"]
    end

    def total_item_count
      items_data.count
    end

    def item_defaults
      @item_defaults ||= {
        "collection" => { "relationship" => "Collection/#{collection_data['unique_id']}" }
      }
    end

    def set_item_defaults(original_item_data)
      item_data = item_defaults.merge(original_item_data)
      if item_data["user_defined_id"].blank?
        item_data["user_defined_id"] = item_data["unique_id"]
      end
      item_data
    end

    def grow!
      set_progress
      grow_collection!
      set_progress
      grow_items!
      set_progress_complete
    end

    def grow_items!
      items_data.each_with_index do |original_item_data|
        item_data = set_item_defaults(original_item_data)
        grow_item!(item_data)
        @item_count += 1
        set_progress
      end
    end

    def grow_brood_record(klass, data)
      Brood::Record.grow(klass: klass, data: data, brood_collection: self)
    end

    def save_brood_record!(klass, data)
      record = grow_brood_record(klass, data)
      record.save!
      record
    end

    def brood_collection
      @brood_collection ||= grow_brood_record(::Collection, collection_data)
    end

    def grow_collection!
      unless SaveCollection.call(brood_collection.record, brood_collection.data)
        error_saving_record(brood_collection)
      end
      fix_config_for_vatican!
    end

    def fix_config_for_vatican!
      record = brood_collection.record
      if ["vatican", "humanrights"].include?(record.unique_id)
        record.collection_configuration.destroy
        record.reload

        CreateCollectionConfiguration.call(record, "vatican_item.yml")
        record.reload
      end
    end

    def grow_item!(data)
      brood_record = grow_brood_record(::Item, data)
      brood_record.record.collection = brood_collection.record
      metadata = brood_record.data.delete(:metadata)
      unless SaveItem.call(brood_record.record, brood_record.data) && SaveMetadata.call(brood_record.record, metadata)
        error_saving_record(brood_record)
      end
    end

    def error_saving_record(brood_record)
      raise "#{brood_record.record.class} #{brood_record.record} not saved: #{brood_record.data}.\n#{brood_record.record.errors.full_messages}"
    end

    def path(path_segment)
      File.join(base_path, path_segment)
    end

    def set_progress
      $stdout.write "\r#{progress_message}"
      $stdout.flush
    end

    def set_progress_complete
      set_progress
      $stdout.write("\n")
    end

    def progress_message
      "Importing collection #{brood_collection.record.unique_id}: #{item_count}/#{total_item_count} items"
    end
  end
end
