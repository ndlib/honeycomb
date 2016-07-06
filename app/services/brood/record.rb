module Brood
  class Record
    attr_reader :record, :original_data, :brood_collection

    def initialize(record:, data:, brood_collection:)
      @record = record
      @original_data = data
      @brood_collection = brood_collection
    end

    def grow
      data.each do |key, value|
        #record.send("#{key}=", value)
      end
    end

    def self.grow(klass:, data:, brood_collection:)
      record = klass.find_or_initialize_by(unique_id: data["unique_id"])
      brood_record = new(record: record, data: data, brood_collection: brood_collection)
      brood_record.grow
      brood_record
    end

    def data
      @data ||= {}.with_indifferent_access.tap do |hash|
        skipped = {}
        original_data.each do |key, original_value|
          value = brood_value(original_value)
          if record.respond_to?("#{key}=") || key == "uploaded_image"
            hash[key] = value
          else
            skipped[key] = value
          end
        end
        if skipped.present?
          hash[:metadata] = skipped
        end
      end
    end

    def brood_value(value)
      if value.is_a?(Hash)
        if value["relationship"]
          find_record(value["relationship"])
        elsif value["file"]
          open_file(value["file"])
        else
          value
        end
      else
        value
      end
    end

    def find_record(value)
      klass_string, unique_id = value.split("/")
      klass = "::#{klass_string}".constantize
      klass.where(unique_id: unique_id).take!
    end

    def open_file(file)
      file = File.open(brood_collection.path("files/#{file}"))
      # This needs to mock ActionDispatch::Http::UploadedFile.original_filename
      class << file
        attr_accessor :original_filename
      end
      file.original_filename = file.path
      file
    end

    def debug(message)
      Rails.logger.debug "[Brood::Record] #{message}"
    end
  end
end
