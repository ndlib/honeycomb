json.name_line_1 @showcase.name_line_1
json.name_line_2 @showcase.name_line_2
json.description @showcase.description
json.editUrl title_showcase_path(@showcase.id)
json.image @showcase.honeypot_image_url
json.set! :sections do
  json.array! @showcase.sections do |section|
    json.partial! "sections/show", section: section
  end
end
