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

  def set_curator
    check_admin_or_admin_masquerading_permission!
    @user =  FindOrCreateUser.call(params[:curator_id])
    @collection =   Collection.find(params[:collection_id])
    if !@user.blank?
      result = AssignUserToCollection.call(@collection, @user)
    end
    if result
      flash[:notice] = "Granted curator status to " + @user.username
      redirect_to collection_path(@collection)
    else
      flash[:error] = "Could not grant curator status to " + params[:curator_id]
      redirect_to collection_path(@collection)
    end
  end

  def user_search
    check_admin_or_admin_masquerading_permission!
    response_list = format_userlist(UserSearch.search(params[:term]))
    respond_to do |format|
      format.any { render json: response_list.to_json, content_type: "application/json" }
    end
  end

  protected

  def user
    @user ||= User.find(params[:username])
  end

  def save_params
    {username: params[:user][:username]}
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
      [
        {
          label: 'User not found',
          value: 'not found'
        }
      ]
    end
  end

end
