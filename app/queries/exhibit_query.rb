class ExhibitQuery
  attr_reader :relation

  def initialize(relation = Exhibit.all)
    @relation = relation
  end

  delegate :find, to: :relation

  def build(args = {})
    relation.build(args)
  end
end
