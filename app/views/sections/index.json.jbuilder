json.set! :sections do
  json.array! @sections.sections do |section|
    json.partial! 'show', section: section
  end
end
