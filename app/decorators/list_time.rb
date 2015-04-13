require 'draper'

class ListTime < Draper::Decorator
  def self.display(time)
    new(time).display
  end

  def display
    if object.today?
      h.l(object.localtime, format: :list_time)
    else
      h.l(object.localtime, format: :list_date)
    end
  end
end
