require 'rails_helper'

RSpec.describe Nav::CollectionTop do
  subject { described_class.new(collection) }
  let(:collection) { double(Collection, id:  1) }
  let(:user) { double(User, username: 'username') }

  it 'renders the footer template' do
    expect(subject.h).to receive(:render).with(partial: 'shared/collection_top_nav', locals: { nav: subject })
    subject.display
  end

  it 'returns the object as collection' do
    expect(subject.collection).to eq(collection)
  end

  it 'recent_collections uses collection query' do
    expect(subject).to receive(:h).and_return(double(current_user: user))
    expect_any_instance_of(CollectionQuery).to receive(:for_top_nav)
    subject.recent_collections
  end
end
