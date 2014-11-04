class MasqueradesController < ApplicationController

  def new
    check_admin_permission!
  end

  def create
    check_admin_permission!

    if params[:username]
      m = Masquerade.new(self)

      if m.start!(params[:username])

        flash[:notice] = "Started masquerading as #{m.masquerading_user.name}"

        redirect_to '/'
        return
      else
        flash[:error] = "Unable to find a user with username #{params[:username]}"
      end
    end

    render :new
  end


  def cancel

    m = Masquerade.new(self)
    if m.masquerading?
      m.cancel!
    end

    flash[:notice] = "Stopped Masquerading and returned to #{m.original_user.name}"
    redirect_to '/'
  end

end
