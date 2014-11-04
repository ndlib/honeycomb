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
    @user = UserManager.create(params.require(:user).permit([:username]))
    redirect_to action: "index"
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
    @user.revoke_admin!
    redirect_to users_path
  end

  def set_admin
    check_admin_or_admin_masquerading_permission!
    @user = User.find(params[:user_id])
    @user.set_admin!
    redirect_to users_path
  end

  protected

  def user
    @user ||= User.find(params[:username])
  end

  def user_params
    { first_name: params[:user][:first_name], last_name: params[:user][:last_name], display_name: params[:user][:display_name], email: params[:user][:email], admin: params[:user][:admin] }
  end

end
