require "rails_helper"

RSpec.describe Nav::CollectionLeft do
  let(:exhibit) { double(Exhibit, id: 1) }
  let(:collection) { double(Collection, id:  1, name_line_1: "Name Line 1", exhibit: exhibit) }
  subject { Nav::CollectionLeft.new(collection) }

  before(:each) do
    allow(collection).to receive(:collection).and_return(collection)
    allow(collection).to receive(:unique_id)
  end

  it "renders the correct template" do
    expect(subject.h).to receive(:render)
      .with(partial: "shared/collection_left_nav", locals: { nav: subject })
    subject.display(:section)
  end

  it "returns the object as collection" do
    expect(subject.collection).to eq(collection)
  end

  # it "sets selected when the left nav section is active" do
  #   subject.display(:section)
  #   expect(subject.active_section_css(:section)).to eq("selected")
  # end

  # it "sets empty when the left nav section is not active" do
  #   subject.display(:section)
  #   expect(subject.active_section_css(:other_section)).to eq("")
  # end
end
