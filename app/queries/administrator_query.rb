class AdministratorQuery
  attr_reader :relation

  def initialize(relation = User.all)
    @relation = relation.where(admin: true)
  end

  def list
    relation.order(:last_name, :first_name)
  end

  delegate :find, to: :relation

  def build(*args)
    relation.build(*args)
  end
end
