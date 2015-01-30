class ItemImageDecorator < Draper::Decorator

  def title
    if object
      object.title
    else
      nil
    end
  end

  def render(style_name = nil, options = {})
    if object && style = style_with_fallback(style_name)
      h.image_tag(style.src, options)
    else
      nil
    end
  end

  def render_image_zoom(options = {})
    if object && dzi
      if Rails.env.development?
        options = options.merge({
          'data-target-height' => original_style.height,
          'data-target-width' => original_style.width
        })
        h.image_zoom(original_style.src, options)
      else
        h.image_zoom(dzi.src, options)
      end
    else
      nil
    end
  end

  def style_with_fallback(style_name)
    style(style_name) || original_style
  end

  def original_style
    style(:original)
  end

  def dzi
    object.dzi
  end

  def style(style_name)
    object.style(style_name)
  end
end
