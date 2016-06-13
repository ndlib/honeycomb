json.set! "@context", "http://bib.schema.org"
json.set! "@type", "Collection"
json.set! "@id", collection_object.at_id
json.set! "additionalType", collection_object.additional_type
json.set! "hasPart/items", collection_object.items_url
json.set! "hasPart/showcases", collection_object.showcases_url
json.set! "hasPart/metadataConfiguration", collection_object.metadata_configuration_url
json.id collection_object.unique_id
json.slug collection_object.slug
json.name collection_object.name
json.enable_browse collection_object.enable_browse
json.enable_search collection_object.enable_search
json.external_url collection_object.external_url
json.name_line_1 collection_object.name_line_1
json.name_line_2 collection_object.name_line_2
json.short_description collection_object.short_intro
json.description collection_object.site_intro
json.about collection_object.about
json.display_page_title collection_object.display_page_title
json.image collection_object.image
json.last_updated collection_object.updated_at
json.copyright collection_object.copyright
