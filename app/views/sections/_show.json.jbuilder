json.id section.id
json.name section.name
json.description section.description
if section.item && section.item.image
  json.image section.item.image.json_response["thumbnail/medium"]["contentUrl"]
end
json.has_spacer section.has_spacer
json.caption section.caption
json.order section.order
json.display_type SectionType.new(section).type
json.editUrl edit_section_path(section.id)
json.updateUrl section_path(section.id)
