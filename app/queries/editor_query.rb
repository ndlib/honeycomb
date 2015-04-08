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

  def find(id)
    relation.find(id)
  end

  def build(*args)
    relation.build(*args)
  end

  private

    def base_relation
      @base_relation
    end
end
