crumb :root do
  link "Home", root_path
end

crumb :collections do ||
  link t("collections.index.title"), collections_path
end

crumb :new_collection do
  link t("collections.index.new"), new_collection_path
  parent :collections
end

crumb :collection do |collection|
  link collection.title, collection_path(collection)
  parent :collections
end

crumb :edit_collection do |collection|
  link t('collections.index.edit', :default => t("helpers.links.edit"))
  parent :collection, collection
end

crumb :collection_items do |collection|
  link t("items.index.title"), collection_items_path(collection)
  parent :collection, collection
end

crumb :new_collection_item do |collection|
  link t("items.index.new"), new_collection_item_path(collection)
  parent :collection_items, collection
end

crumb :collection_item do |item|
  link item.title, collection_item_path(item.collection, item)
  parent :collection_items, item.collection
end

crumb :edit_collection_item do |item|
  link t('items.index.edit', :default => t("helpers.links.edit"))
  parent :collection_item, item
end

crumb :collection_item_children do |parent_item|
  link t('item_children.index.title'), collection_item_children_path(parent_item.collection, parent_item)
  parent :collection_item, parent_item
end

crumb :new_collection_item_child do |parent_item|
  link t("item_children.index.new"), new_collection_item_child_path(parent_item.collection, parent_item)
  parent :collection_item_children, parent_item
end

crumb :collection_item_child do |child_item|
  link child_item.title, collection_item_path(child_item.collection, child_item)
  parent :collection_item_children, child_item.parent
end

crumb :edit_collection_item_child do |child_item|
  link t('item_children.index.edit', :default => t("helpers.links.edit")), edit_collection_item_path(child_item.collection, child_item)
  parent :collection_item_child, child_item
end


# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
