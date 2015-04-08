class EditorsController < ApplicationController
  def index
    @collection = CollectionQuery.new.find(params[:collection_id])
    check_user_edits!(@collection)
    collection_users = @collection.collection_users
    @editor_list = CollectionUserListDecorator.new(collection_users)
  end

  def create
    collection = CollectionQuery.new.find(params[:collection_id])
    check_user_edits!(collection)

    user =  FindOrCreateUser.call(create_params[:username])
    if collection_user = AssignUserToCollection.call(collection, user)
      @collection_user = CollectionUserDecorator.new(collection_user)
      respond_to do |format|
        format.any { render json: @collection_user.editor_hash, status: 200 }
      end
    else
      respond_to do |format|
        format.any { render json: { status: 'error'}, status: 500 }
      end
    end
  end

  def destroy
    @collection = CollectionQuery.new.find(params[:collection_id])
    check_user_edits!(@collection)

    @user =  User.find(params[:id])
    if @user.present?
      if RemoveUserFromCollection.call(@collection, @user)
        flash[:notice] = t('.success')
      else
        flash[:error] = t('.failure')
      end
    end
    redirect_to collection_editors_path(@collection.id)
  end

  def user_search
    @collection = CollectionQuery.new.find(params[:collection_id])
    check_user_edits!(@collection)

    search_results = PersonAPISearch.call(params[:q])
    respond_to do |format|
      format.any { render json: search_results.to_json, content_type: "application/json" }
    end
  end

  private

  def create_params
    params.require(:user).permit(:username)
  end
end
