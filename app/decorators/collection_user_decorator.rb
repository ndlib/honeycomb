class CollectionUserDecorator < Draper::Decorator
  def editor_hash
    {
      id: id,
      name: name,
      username: username,
      removeUrl: destroy_path
    }
  end

  def editor_json
    editor_hash.to_json
  end

  def id
    object.user_id
  end

  def name
    user.display_name
  end

  delegate :username, to: :user

  def destroy_path
    h.collection_editor_path(object.collection_id, object.user_id)
  end

  private

  def user
    object.user
  end
end
