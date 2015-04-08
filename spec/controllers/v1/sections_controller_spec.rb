require 'rails_helper'

RSpec.describe V1::SectionsController, type: :controller do
  let(:collection) { instance_double(Collection, id: '1') }
  let(:section) { instance_double(Section, id: '1') }

  before(:each) do
    allow_any_instance_of(SectionQuery).to receive(:public_find).and_return(section)
  end

  describe '#show' do
    subject { get :show, id: 'id', format: :json }
    it 'calls ShowcaseQuery' do
      expect_any_instance_of(SectionQuery).to receive(:public_find).with('id').and_return(section)

      subject
    end

    it 'is successful' do
      subject

      expect(response).to be_success
      expect(assigns(:section)).to be_present
      expect(subject).to render_template('v1/sections/show')
    end
  end
end
