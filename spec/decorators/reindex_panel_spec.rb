require "rails_helper"

RSpec.describe ReindexPanel do
  subject { described_class.new(object) }
  let(:object) { double(Collection, id: 1) }

  before(:each) do
    allow(subject.h).to receive(:url_for).and_return('/collections/1')
  end

  it "renders the reindex section template" do
    required_locals = { path: '/collections/1/reindex' }
    expect(subject.h).to receive(:render).with(partial: "shared/reindex_panel", locals: hash_including(required_locals))
    subject.display
  end

  it "allows the path to be set" do
    subject.display do |ds|
      ds.path = "/path"
    end

    expect(subject.path).to eq("/path")
  end
end
