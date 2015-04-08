class SectionQuery
  attr_reader :relation

  def initialize(relation = Section.all)
    @relation = relation
  end

  def all_in_showcase
    relation.order(:order)
  end

  def public_find(id)
    relation.find_by!(unique_id: id)
  end

  def find(id)
    relation.find(id)
  end

  def build(args = {})
    relation.build(args)
  end


  def next(section)
    relation.where(showcase_id: section.showcase_id).where("`#{relation.table_name}`.order > ?", section.order).order(:order).first
  end

  def previous(section)
    relation.where(showcase_id: section.showcase_id).where("`#{relation.table_name}`.order < ?", section.order).order(order: :desc).first
  end

end
