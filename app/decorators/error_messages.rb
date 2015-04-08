class ErrorMessages < Draper::Decorator
  delegate_all

  def display_error
    h.render 'shared/error_messages', obj: object if errors.any?
  end
end
