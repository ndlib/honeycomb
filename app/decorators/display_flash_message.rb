require 'draper'

class DisplayFlashMessage < Draper::Decorator
  KEY_2_CSS_CLASS = {
    notice: 'alert alert-info',
    alert: 'alert alert-warning',
    success: 'alert alert-success',
    error: 'alert alert-danger'
  }

  delegate_all

  def display
    txt = ""
    flash_keys.each do | key |
      txt += display_flash_message(key)
    end

    h.raw(txt)
  end

  private

    def flash_keys
      [:notice, :alert, :success, :error]
    end

    def display_flash_message(key)
      if object[key].present?
        h.render 'shared/display_flash_message', content: object[key], css_class: KEY_2_CSS_CLASS[key]
      else
        ""
      end
    end
end

