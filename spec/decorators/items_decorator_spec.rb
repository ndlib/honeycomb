require 'rails_helper'

RSpec.describe ItemsDecorator do
  let(:item) { instance_double(Item) }
  let(:items) { [item] }
  subject { described_class.new(items) }

  it "decorates with ItemDecorator" do
    expect(subject.first).to be_a_kind_of(ItemDecorator)
    expect(subject.first.object).to eq(item)
  end
end
