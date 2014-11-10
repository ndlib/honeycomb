require "rails_helper"

RSpec.describe Item do
  let (:image_with_spaces) {  File.open(Rails.root.join('spec/fixtures', 'test copy.jpg'), 'r') }

  [:title, :description, :collection, :tiled_image].each do | field |

    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  it "requires the title field " do
    expect(subject).to have(1).error_on(:title)
  end

  it "requires the collection field" do
    expect(subject).to have(1).error_on(:collection)
  end

  it "requires that the item have an image" do
    expect(subject).to have(1).error_on(:image)
  end

  it "has versioning " do
    expect(subject).to respond_to(:versions)
  end

  it "keeps spaces in the original filename" do
    subject.image = image_with_spaces
    expect(subject.image.original_filename).to eq("test copy.jpg")
  end
end
