json.set! "@type", "SearchHit"
json.set! "@id", hit.at_id
json.set! "isPartOf/item", hit.part_parent
json.type hit.type
json.name hit.name
json.shortDescription hit.short_description
json.description hit.description
json.thumbnailURL hit.thumbnail_url
json.updated hit.last_updated
