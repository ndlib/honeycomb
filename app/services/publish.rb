class Publish
  attr_reader :object

  def self.call(object)
    new(object).publish!
  end

  def initialize(object)
    @object = object
    validate_interface!
  end

  def publish!
    @object.published = true
    @object.save
  end

  private

  def validate_interface!
    unless object.respond_to?('published=')
      fail 'Object passed to publish is not valid'
    end
  end
end
