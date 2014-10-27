require "rails_helper"

RSpec.describe Item do
  [:title, :description, :collection].each do | field |

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

  it "has versioning " do
    expect(subject).to respond_to(:versions)
  end
end
