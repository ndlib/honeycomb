class CreateURLSlug
  attr_reader :name

  def self.call(name)
    new(name).create
  end

  def initialize(name)
    @name = name
  end

  def create
    if name.present?
      name.downcase.gsub(/\s+/, "-").gsub(/[^0-9a-z-]/i, "")
    else
      "name"
    end
  end
end
