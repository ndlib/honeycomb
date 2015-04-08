class ErrorsController < ApplicationController
  include ErrorHelper

  layout 'errors'

  def index
    check_admin_or_admin_masquerading_permission!
    @errors = ErrorLog.errors
  end

  def show
    check_admin_or_admin_masquerading_permission!

    @error = ErrorLog.find(params[:id])

    if @error.start
      @error.save!
    end
  end

  def update
    check_admin_or_admin_masquerading_permission!

    @error = ErrorLog.find(params[:id])

    if @error.resolve
      flash[:notice] = "Resolved Error ##{@error.id}"
      @error.save!
    end

    redirect_to errors_path
  end
end
