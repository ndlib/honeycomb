class MediaQuery
  attr_reader :relation

  def initialize(relation = Media.all)
    @relation = relation
  end

  def public_find(id)
    relation.find_by!(uuid: id)
  end
end
