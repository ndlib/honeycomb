namespace :db do
  desc "Drops, creates, migrates, seeds, and prepares the test database"
  task rebuild: :environment do
    unless Rails.env.development?
      fail "Only allowed in development"
    end
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:test:prepare"].invoke
    Rake::Task["db:seed"].invoke
  end

  desc "Empties a collection's items, showcases, and pages. Similar to Destroy::Collection, but leaves the configuration and editors in tact."
  task :empty_collection, [:collection_id] => :environment do |_t, args|
    destroy_showcase = Destroy::Showcase.new
    destroy_item = Destroy::Item.new
    destroy_page = Destroy::Page.new
    collection = Collection.find(args[:collection_id])

    ActiveRecord::Base.transaction do
      collection.showcases.each do |child|
        destroy_showcase.force_cascade!(showcase: child)
      end
      collection.items.each do |child|
        destroy_item.cascade!(item: child)
      end
      collection.pages.each do |child|
        destroy_page.force_cascade!(page: child)
      end
    end
  end
end
