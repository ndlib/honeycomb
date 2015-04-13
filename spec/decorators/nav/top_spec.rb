require 'rails_helper'

RSpec.describe Nav::Top do
  subject { described_class.new(controller) }
  let(:controller) { double(current_user: nil_current_user) }
  let(:nil_current_user) { nil }
  let(:user) { double(User, display_name: 'DisplayName') }

  it 'renders the footer template' do
    expect(subject.h).to receive(:render).with(partial: 'shared/top_nav', locals: { nav: subject })
    subject.display
  end

  it 'determins the  display name from the current user' do
    controller.stub(:current_user).and_return(user)
    expect(subject.current_user_display_name).to eq('DisplayName')
  end

  it 'determins the  display name from the current user if there is no current user' do
    expect(subject.current_user_display_name).to eq('no user')
  end

  it 'determins the css class for the top nav to be large if it is the root_path' do
    expect(subject.h.request).to receive(:original_fullpath).and_return('/')
    expect(subject.bar_size_class).to eq('large')
  end

  it 'determins the css class for the top nav to be short if it is not the root_path' do
    expect(subject.h.request).to receive(:original_fullpath).and_return('/asdfdsaf/')
    expect(subject.bar_size_class).to eq('short')
  end
end
