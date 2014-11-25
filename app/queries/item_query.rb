class ItemQuery
  attr_reader :search
  def initialize(relation = Item.all)
    @search = extend_relation(relation)
  end

  def recent(limit = 5)
    search.recent(limit)
  end

  module Scopes
    def recent(limit = 5)
      order(updated_at: :desc).limit(limit)
    end

    def exclude_children
      where(parent_id: nil)
    end
  end

  private

  def extend_relation(relation)
    relation.extending(Scopes)
  end
end
