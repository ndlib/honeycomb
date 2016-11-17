class ShowcaseQuery
  attr_reader :relation

  def initialize(relation = Showcase.all)
    @relation = relation
  end

  def all
    relation
  end

  def admin_list
    relation.order(:name_line_1)
  end

  def public_api_list
    relation.order(:name_line_1)
  end

  delegate :find, to: :relation

  def build(args = {})
    relation.build(args)
  end

  def public_find(id)
    relation.find_by!(unique_id: id)
  end

  def can_delete?
    CanDelete.showcase?(relation)
  end
end
