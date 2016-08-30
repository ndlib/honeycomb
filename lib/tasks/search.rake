namespace :search do
  desc "reindex all content"
  task index_all: :environment do
    Index::Item.index_all!(Item.all)
  end

  desc "remove all content"
  task remove_all: :environment do
    Index::Item.remove_all!(Item.all)
  end

  desc "rebuild search index"
  task rebuild: :environment do
    Rake::Task["search:remove_all"].invoke
    Rake::Task["search:index_all"].invoke
  end
end
