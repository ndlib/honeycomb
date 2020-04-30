json.set! "@type", "SearchFacet"
json.name facet.name
json.field facet.field
json.values facet.values do |value|
  json.set! "@type", "SearchFacetValue"
  json.name value.name
  json.value value.value
  json.count value.count
end
json.order facet.order
