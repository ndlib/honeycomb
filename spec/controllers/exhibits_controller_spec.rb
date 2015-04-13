require 'rails_helper'

RSpec.describe ExhibitsController, type: :controller do
  let(:exhibit) { double(Exhibit, id: 1, title: 'title', collection: collection, save: true, 'attributes=' => true) }
  let(:collection) { instance_double(Collection, id: 1, title: 'title') }
  let(:update_params) { { id: exhibit.id, exhibit: {  description: 'description' } } }

  before(:each) do
    sign_in_admin

    allow_any_instance_of(ExhibitQuery).to receive(:find).and_return(exhibit)
    allow(SaveExhibit).to receive(:call).and_return(true)
  end

  describe 'show' do
    subject { get :show, id: '1' }
    it 'redirects to the items page' do
      subject

      expect(response).to redirect_to exhibit_showcases_path('1')
    end
  end

  describe 'edit' do
    subject { get :edit, id: exhibit.id }

    it 'checks the curator permissions' do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it 'uses  query ' do
      expect_any_instance_of(ExhibitQuery).to receive(:find).with('1').and_return(exhibit)
      subject
    end

    it 'assigns a exhibit' do
      subject

      assigns(:exhibit)
      expect(assigns(:exhibit)).to eq(exhibit)
    end
  end

  describe 'update' do
    subject { put :update, update_params }

    it 'checks the curator permissions' do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it 'uses exhibit query ' do
      expect_any_instance_of(ExhibitQuery).to receive(:find).with('1').and_return(exhibit)
      subject
    end

    it 'redirects on success' do
      subject

      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it 'renders new on failure' do
      allow(SaveExhibit).to receive(:call).and_return(false)

      subject
      expect(response).to render_template('edit')
    end

    it 'assigns a exhibit' do
      subject

      assigns(:exhibit)
      expect(assigns(:exhibit)).to eq(exhibit)
    end

    it 'uses the save exhibit service' do
      expect(SaveExhibit).to receive(:call).with(exhibit, update_params[:exhibit]).and_return(true)

      subject
    end
  end
end
