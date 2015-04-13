class CreateURLSlug
  attr_reader :title

  def self.call(title)
    new(title).create
  end

  def initialize(title)
    @title = title
  end

  def create
    if title.present?
      title.downcase.gsub(/\s+/, '-').gsub(/[^0-9a-z-]/i, '')
    else
      'title'
    end
  end
end
