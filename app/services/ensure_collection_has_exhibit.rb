class EnsureCollectionHasExhibit
  attr_reader :collection

  def self.call(collection)
    new(collection).ensure
  end

  def initialize(collection)
    @collection = collection
  end

  def ensure
    unless collection.exhibit
      create!
    end

    collection.exhibit
  end

  private

  def create!
    copyright_default = '<p><a href="http://www.nd.edu/copyright/">Copyright</a> ' +
                        Date.today.year.to_s +
                        ' <a href="http://www.nd.edu">University of Notre Dame</a></p>'
    collection.create_exhibit(name: collection.name_line_1, copyright: copyright_default)
  end
end
