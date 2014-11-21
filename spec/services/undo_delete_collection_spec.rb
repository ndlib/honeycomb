require "rails"

describe RestoreCollection do

  subject { RestoreCollection.call(collection) }
  let(:collection) { double(Collection, title: 'title') }

  it "sets the deleted value to true" do
    expect(collection).to receive("deleted=").with(false)
    expect(collection).to receive("save")
    subject
  end
end
