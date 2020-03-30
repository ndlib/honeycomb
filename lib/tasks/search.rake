class ProgressBar

 def initialize(total, description)
   @total   = total
   @description = description
   @counter = 1
 end

 def increment
   complete = sprintf("%#.2f%", ((@counter.to_f / @total.to_f) * 100))
   print "\r\e[0K#{@description} #{@counter}/#{@total} (#{complete})" + (@counter == @total ? "\n" : "")
   @counter += 1
 end

end

namespace :search do
  desc "index all items in a collection"
  task :index, [:collection_id] => :environment do |task, args|
    collection = Collection.find(args.collection_id)
    progress_bar = ProgressBar.new(collection.items.size, "Indexing Collection Items:")

    Index::Collection.index!(collection: collection, progress_bar: progress_bar)
  end

  desc "remove all items in a collection from the index"
  task :remove, [:collection_id] => :environment do |task, args|
    collection = Collection.find(args.collection_id)
    progress_bar = ProgressBar.new(collection.items.size, "Removing Collection Items:")

    Index::Collection.remove!(collection: collection, progress_bar: progress_bar)
  end

  desc "reindex items for a collection"
  task :reindex, [:collection_id] => :environment do |task, args|
    Rake::Task["search:remove"].invoke(args.collection_id)
    Rake::Task["search:index"].invoke(args.collection_id)
  end

  desc "reindex all content"
  task index_all: :environment do
    progress_bar = ProgressBar.new(Item.all.size, "Indexing Items:")
    Collection.all.each do |collection|
      Index::Collection.index!(collection: collection, progress_bar: progress_bar)
    end
  end

  desc "remove all content"
  task remove_all: :environment do
    Index::Item.remove_all()
  end

  desc "rebuild search index"
  task rebuild: :environment do
    Rake::Task["search:remove_all"].invoke
    Rake::Task["search:index_all"].invoke
  end
end
