class ErrorMessages < Draper::Decorator
	delegate_all

	def display_error
	  if errors.any?
	    h.render 'shared/error_messages', obj: object
	  end
	end

end

