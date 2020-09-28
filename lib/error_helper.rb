module ErrorHelper
  def catch_404(_exception = nil)
    @masquerading_user = determine_masquerade

    respond_to do |format|
      format.html { render template: "errors/error_404", status: 404 }
    end
  end

  def catch_500(exception = nil)
    @masquerading_user = determine_masquerade
    if exception.present?
      Raven.capture_exception(exception)
      logger.error exception.message
      logger.error Rails.backtrace_cleaner.clean(exception.backtrace).join("\n")
    end

    respond_to do |format|
      format.html { render template: "errors/error_500", status: 500 }
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
