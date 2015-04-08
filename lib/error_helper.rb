module ErrorHelper
  def catch_404(_exception = nil)
    @masquerading_user = determine_masquerade

    respond_to do |format|
      format.html { render template: 'errors/error_404', status: 404 }
    end
  end

  def catch_500(exception = nil)
    @masquerading_user = determine_masquerade

    unless exception.nil?
      # ExceptionNotifier.notify_exception(exception, { :env => request.env })
    end

    respond_to do |format|
      format.html { render template: 'errors/error_404', status: 500 }
    end
  end

  def determine_masquerade
    masquerade = Masquerade.new(self)
    if masquerade.masquerading?
      return masquerade.original_user
    end

    false
  end
end
