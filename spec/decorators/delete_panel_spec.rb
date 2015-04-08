require 'rails_helper'

RSpec.describe DeletePanel do
  subject { described_class.new(object) }
  let(:object) { Object.new }

  it 'renders the delete section template' do
    # removed because it errors in a strange way
    expect(subject.h).to receive(:render).with(partial: 'shared/delete_panel', locals: { default_name: 'Object', path: object, i18n_key_base: 'objects.delete_panel' })
    subject.display
  end

  it 'allows the path to be set' do
    subject.display do |ds|
      ds.path = '/path'
    end

    expect(subject.path).to eq('/path')
  end
end
