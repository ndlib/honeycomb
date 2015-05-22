json.set! "@context", "http://schema.org"
json.set! "@type", "CreativeWork"
json.set! "@id", section_object.at_id
json.set! "isPartOf/showcase", section_object.showcase_url
json.set! "isPartOf/collection", section_object.collection_url
json.id section_object.unique_id
json.slug section_object.slug
json.name section_object.name
json.order section_object.order
json.description section_object.description
json.caption section_object.caption
json.last_updated section_object.updated_at
