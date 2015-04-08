require 'rails_helper'


describe ShowcaseList do
  subject { described_class.new(sections, showcase)}

  let(:sections) { ['section1', 'section2']}
  let(:showcase) { double(Showcase, exhibit: exhibit, id: 1 )}
  let(:exhibit) { double(Exhibit, id: 1) }

  it "returns the sections passed in" do
    expect(subject.sections).to be(sections)
  end

  it "returns the showcase" do
    expect(subject.showcase).to be(showcase)
  end

  it "returns the exhibit" do
    expect(subject.exhibit).to be(exhibit)
  end

end
