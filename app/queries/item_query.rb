class ItemQuery
  attr_reader :relation

  def initialize(relation = Item.all)
    @relation = relation
  end

  def recent(limit = 5)
    relation.order(updated_at: :desc).limit(limit)
  end

  def only_top_level
    relation.where(parent_id: nil).includes(:media)
  end

  delegate :find, to: :relation

  def build(args = {})
    relation.build(args)
  end

  def published
    relation.all
  end

  def public_find(id)
    relation.find_by!(unique_id: id)
  end

  def parent(id)
    relation.where(id: relation.select(:parent_id).where(unique_id: id)).take!
  end

  def can_delete?
    CanDelete.item?(relation)
  end
end
