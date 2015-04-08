class EditorQuery
  def initialize(base_relation = User.all)
    @base_relation = base_relation
  end

  def relation
    @relation ||= base_relation.includes(:collections).where.not(collections: { id: nil })
  end

  def list
    relation.order(:last_name, :first_name)
  end

  delegate :find, to: :relation

  def build(*args)
    relation.build(*args)
  end

  private

  attr_reader :base_relation
end
