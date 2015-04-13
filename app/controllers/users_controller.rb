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
    user = User.new
    if CreateUser.call(user, save_params)
      flash[:notice] = t('.success')
      redirect_to action: 'index'
    else
      flash[:error] = t('.failure')
      redirect_to action: create
    end
  end

  def destroy
    check_admin_or_admin_masquerading_permission!
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = t('.success')
    else
      flash[:error] = t('.failure')
    end

    redirect_to users_path
  end

  def edit
    check_admin_or_admin_masquerading_permission!
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    check_admin_or_admin_masquerading_permission!
    @user = User.find(params[:id])
    @user.save
    redirect_to user_path
  end

  def revoke_admin
    check_admin_or_admin_masquerading_permission!
    @user = User.find(params[:user_id])
    RevokeAdminOnUser.call(@user)
    flash[:notice] = 'Revoked admin from ' + @user.username
    redirect_to users_path
  end

  def set_admin
    check_admin_or_admin_masquerading_permission!
    @user = User.find(params[:user_id])
    SetAdminOnUser.call(@user)
    flash[:notice] = 'Granted admin to ' + @user.username
    redirect_to users_path
  end

  protected

  def user
    @user ||= User.find(params[:username])
  end

  def save_params
    { username: params[:user][:username] }
  end

  private

  def format_userlist(results)
    if !results.blank?
      results.map do |result|
        {
          id: result['uid'],
          label: result['full_name'],
          value: result['full_name']
        }
      end
    else
      []
    end
  end
end
