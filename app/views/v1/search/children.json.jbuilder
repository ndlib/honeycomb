json.set! "@type", "SearchResult"
json.hits do
  json.found @search.total
  json.start @search.start
  if @search.is_grouped
    json.group @search.groups do |group|
      json.partial! "v1/search/group", group: group
    end
  else
    json.hit @search.hits do |hit|
      json.partial! "v1/search/hit", hit: hit
    end
  end
end
json.facets @search.facets do |facet|
  json.partial! "v1/search/facet", facet: facet
end
json.sorts @search.sorts do |sort_field|
  json.partial! "v1/search/sort_field", sort_field: sort_field
end
