require "rails_helper"

RSpec.describe CollectionNavCss do
  subject { described_class}

  [:settings, :items, :exhibits].each do | section |
    it "returns active when the to sections match, #{section}" do
      expect(subject.call(section, section)).to eq("active")
    end

    it "returns false if the sections do not mactch" do
      expect(subject.call('other', section)).to eq("")
    end
  end

  it "raises if the section is not found" do
    expect { subject.call(:items, "asdfasdfadsf")}.to raise_error
  end
end
