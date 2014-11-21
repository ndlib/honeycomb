require "rails"

describe SoftDeleteCollection do

  subject { SoftDeleteCollection.call(collection) }
  let(:collection) { double(Collection, title: 'title') }

  it "sets the deleted value to true" do
    expect(collection).to receive("deleted=").with(true)
    expect(collection).to receive("save")
    subject
  end
end
