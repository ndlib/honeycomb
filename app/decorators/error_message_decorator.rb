class ErrorMessageDecorator < Draper::Decorator
  delegate_all
  
  def display_error
    if errors.any?
      h.render 'shared/error_message', obj: object
    end
  end

end
