class UsersController < ApplicationController

  helper_method :user

  def index
    check_admin_or_admin_masquerading_permission!
    @users = User.all
  end

  def new
    check_admin_or_admin_masquerading_permission!
    @user = User.new
  end

  def create
    check_admin_or_admin_masquerading_permission!
    @user = User.new
    if CreateUser.call(@user, save_params)
      flash[:notice] = "New user created successfully."
      redirect_to action: "index"
    else
      flash[:notice] = "User could not be created. Check that you entered a valid username and that the user does not already exist."
      redirect_to action: "index"
    end
  end

  def destroy
    check_admin_or_admin_masquerading_permission!
    @user = User.find(params[:id])
    @user.delete()

    redirect_to users_path
  end

  def edit
    check_admin_or_admin_masquerading_permission!

    @user = User.find(params[:id])
  end


  def update
    check_admin_or_admin_masquerading_permission!

    @user = User.find(params[:id])
    @user.admin = true
    @user.save
    redirect_to users_path
  end

  def revoke_admin
    check_admin_or_admin_masquerading_permission!
    @user = User.find(params[:user_id])
    RevokeAdminOnUser.call(@user)
    flash[:notice] = "Revoked admin from " + @user.username
    redirect_to users_path
  end

  def set_admin
    check_admin_or_admin_masquerading_permission!
    @user = User.find(params[:user_id])
    SetAdminOnUser.call(@user)
    flash[:notice] = "Granted admin to " + @user.username
    redirect_to users_path
  end

  def user_search
    check_admin_or_admin_masquerading_permission!
    response = UserSearch.search(params[:term])
    respond_to do |format|
      format.any { render json: response.to_json, content_type: "application/json" }
    end
  end

  protected

  def user
    @user ||= User.find(params[:username])
  end

  def save_params
    {username: params[:user][:username]}
  end

end
