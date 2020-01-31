# Before using this, make sure local_upload is updated to replicate anything new that has been
# added to the items_controller#create code path

namespace :adhoc do
  desc "Warning: This code is not maintained, and will likely only be here temporarily.
        Uploads and creates new items using all images specified in a text file."

  # file_path must point to a text file that has full paths to each file to import, separated
  # by new lines. Ex:
  # $ cat image_paths.txt
  # /Users/jgondron/Documents/1.tif
  # /Users/jgondron/Documents/2.tif
  #
  # Example usage:
  # bundle exec rake adhoc:upload_images[49,"image_paths.txt"]
  #
  # If it encounters an error importing a file, it will append that file to an error file
  # of the same name as the given file with .err added. Ex:
  #   bundle exec rake adhoc:upload_images[49,"image_paths.txt"]
  # will create a image_paths.txt.err file with a list of files that were not imported.
  task :upload_images, [:collection_id, :file_path] => :environment do |_t, args|
    paths_file = File.new(args[:file_path], "r")
    success_file = open("#{args[:file_path]}.success", "a")
    error_file = open("#{args[:file_path]}.error", "a")
    while (line = paths_file.gets)
      begin
        local_upload(collection_id: args[:collection_id], file_path: line.chomp)
        success_file << "#{line}"
      rescue => e
        print "#{line}: #{e}\n"
        error_file << "#{line}"
        next
      end
    end
    paths_file.close
  end

  def local_upload(collection_id:, file_path:)
    file = URI.parse(file_path)
    file_name = File.basename(file.respond_to?(:base_uri) ? file.base_uri.path : file.path)

    item = get_item(collection_id: collection_id, file_name: file_name)
    Metadata::Setter.call(item, { name: file_name })
    result = SaveItem.call(item, { uploaded_image: file })
    Index::Item.index!(item)
    result
  end

  # Assumes that any previous items in the collection were named based on the file name.
  def get_item(collection_id:, file_name:)
    item = Item.where("metadata->'name' ? '#{file_name}'").where(collection_id: collection_id).take
    unless item.present?
      item = Item.new(collection_id: collection_id)
    end
    item
  end
end
