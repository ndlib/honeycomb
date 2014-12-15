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
      redirect_to action: "index"
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
    @collection =  Collection.find(params[:collection_id])
    unless @user.blank?
      AssignUserToCollection.call(@collection, @user)
      flash[:notice] = "Granted curator status to " + @user.name
      redirect_to edit_collection_path(@collection)
    else
      flash[:error] = "Could not grant curator status to specified user"
      redirect_to edit_collection_path(@collection)
    end
  end

  def remove_curator
    check_admin_or_admin_masquerading_permission!
    @user =  User.find(params[:curator_id])
    @collection =  Collection.find(params[:collection_id])
    unless @user.blank?
      if RemoveUserFromCollection.call(@collection, @user)
        flash[:notice] = "Removed curator " + @user.name
        redirect_to edit_collection_path(@collection)
      else
        flash[:error] = "Could not remove specified curator"
        redirect_to edit_collection_path(@collection)
      end
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
