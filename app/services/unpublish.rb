class Unpublish
  attr_reader :object

  def self.call(object)
    new(object).unpublish!
  end

  def initialize(object)
    @object = object
    validate_interface!
  end

  def unpublish!
    @object.published = false
    @object.save
  end

  private

  def validate_interface!
    return true if object.respond_to?('published=')

    fail 'Object passed to publish is not valid'
  end
end
