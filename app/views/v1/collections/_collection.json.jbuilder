json.set! "@context", "http://schema.org"
json.set! "@type", "CreativeWork"
json.set! "@id", collection_object.at_id
json.set! "hasPart/items", collection_object.items_url
json.set! "hasPart/showcases", collection_object.showcases_url
json.id collection_object.unique_id
json.slug collection_object.slug
json.name collection_object.name
json.name_line_1 collection_object.name_line_1
json.name_line_2 collection_object.name_line_2
json.short_description collection_object.short_intro
json.description collection_object.site_intro
json.about collection_object.about
json.image collection_object.image
json.last_updated collection_object.updated_at
