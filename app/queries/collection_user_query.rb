class CollectionUserQuery
  attr_reader :relation

  def initialize(relation = CollectionUser.all)
    @relation = relation
  end

  delegate :all, to: :relation
end
