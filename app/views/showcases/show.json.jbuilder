json.title @showcase.title
json.description @showcase.description
json.editUrl title_showcase_path(@showcase.id)
json.set! :sections do
  json.array! @showcase.sections do | section |
    json.partial! 'sections/show', section: section
  end
end
