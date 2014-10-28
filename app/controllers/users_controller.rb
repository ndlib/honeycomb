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
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "#{@user.username} created successfully!"

      redirect_to action: "edit", id: @user
      return
    end

    render :new
  end

  def destroy
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
    redirect_to users_path
  end
  protected

  def save_params
    { first_name: params[:user][:first_name], last_name: params[:user][:last_name], display_name: params[:user][:display_name], email: params[:user][:email], username: params[:user][:username] }
  end


  def user
    @user ||= Yser.find(params[:username])
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end

end
