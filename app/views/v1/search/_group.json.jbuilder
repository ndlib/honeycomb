json.groupId group.fetch(:id, "")
json.hits group.fetch(:hits, []) do |hit|
  json.partial! "v1/search/hit", hit: hit
end
