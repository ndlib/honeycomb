class CollectionQuery
  attr_reader :relation

  def initialize(relation = Collection.all)
    @relation = relation
  end

  def for_top_nav(user, collection)
    for_editor(user).order(updated_at: :desc).where.not(id: collection.id)
  end

  def for_editor(user)
    if UserIsAdmin.call(user)
      relation.all
    else
      user.collections
    end
  end

  def public_collections
    relation.all
  end

  def public_find(id)
    relation.find_by!(unique_id: id)
  end

  def recent(limit = 5)
    relation.order(updated_at: :desc).limit(limit)
  end

  delegate :find, to: :relation

  delegate :build, to: :relation
end
