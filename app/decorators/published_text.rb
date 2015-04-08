require 'draper'

class PublishedText < Draper::Decorator
  def self.display(object)
    new(object).display
  end

  def display
    if object.published
      h.content_tag('span', class: 'text-success') do
        h.content_tag('i', '', class: 'glyphicon glyphicon-ok') + ' ' +
          h.t('published.published')
      end
    else
      h.content_tag('span', class: 'text-muted') do
        h.content_tag('i', '', class: 'glyphicon glyphicon-ok') + ' ' +
          h.t('published.unpublished')
      end
    end

    h.content_tag('span', class: 'text-success') do
      h.content_tag('i', '', class: 'glyphicon glyphicon-ok') + ' ' +
        h.t('published.published')
    end
  end

  private
end
