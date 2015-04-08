require "rails_helper"

RSpec.describe ShowcasesController, :type => :controller do
  let(:showcase) { instance_double(Showcase, id: 1, title: 'title', exhibit: exhibit, destroy!: true, collection: collection) }
  let(:exhibit) { instance_double(Exhibit, id: 1, title: 'title', showcases: relation, collection: collection) }
  let(:collection) { instance_double(Collection, id: 1, title: 'title') }

  let(:relation) { Showcase.all }
  let(:create_params) { {exhibit_id: exhibit.id, showcase: { title: 'title', description: 'description' }} }
  let(:update_params) { {id: showcase.id, showcase: { title: 'title', description: 'description' }} }

  before(:each) do
    sign_in_admin

    allow_any_instance_of(ExhibitQuery).to receive(:find).and_return(exhibit)
    allow_any_instance_of(ShowcaseQuery).to receive(:find).and_return(showcase)
    allow_any_instance_of(ShowcaseQuery).to receive(:build).and_return(showcase)
    allow(SaveShowcase).to receive(:call).and_return(true)
  end

  describe "GET #index" do
    subject { get :index, exhibit_id: exhibit.id }

    it "returns a 200" do
      subject

      expect(response).to be_success
      expect(response).to render_template("index")
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "users the item query to get items" do
      expect_any_instance_of(ShowcaseQuery).to receive(:all)
      subject
    end

    it "assigns an item decorator to items" do
      subject
      assigns(:showcases)
      expect(assigns(:showcases)).to be_a(ActiveRecord::Relation)
    end
  end

  describe "GET #new" do
    subject { get :new, exhibit_id: exhibit.id }

    it "returns a 200" do
      subject

      expect(response).to be_success
      expect(response).to render_template("new")
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses item query " do
      expect_any_instance_of(ShowcaseQuery).to receive(:build).and_return(showcase)
      subject
    end

    it "assigns and item and it is an item decorator" do
      subject

      assigns(:showcase)
      expect(assigns(:showcase)).to eq(showcase)
    end
  end

  describe "POST #create" do
    subject { post :create, create_params }

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses showcase query " do
      expect_any_instance_of(ShowcaseQuery).to receive(:build).and_return(showcase)
      subject
    end

    it "redirects on success" do
      subject

      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "renders new on failure" do
      allow(SaveShowcase).to receive(:call).and_return(false)

      subject
      expect(response).to render_template("new")
    end

    it "assigns a showcase" do
      subject

      assigns(:showcase)
      expect(assigns(:showcase)).to eq(showcase)
    end

    it "uses the save showcase service" do
      expect(SaveShowcase).to receive(:call).with(showcase, update_params[:showcase]).and_return(true)

      subject
    end
  end

  describe "PUT #update" do
    subject { put :update, update_params }

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses showcase query " do
      expect_any_instance_of(ShowcaseQuery).to receive(:find).with("1").and_return(showcase)
      subject
    end

    it "redirects on success" do
      subject

      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "renders new on failure" do
      allow(SaveShowcase).to receive(:call).and_return(false)

      subject
      expect(response).to render_template("edit")
    end

    it "assigns a showcase" do
      subject

      assigns(:showcase)
      expect(assigns(:showcase)).to eq(showcase)
    end

    it "uses the save showcase service" do
      expect(SaveShowcase).to receive(:call).with(showcase, update_params[:showcase]).and_return(true)

      subject
    end
  end

  describe "GET #show" do
    subject { get :show, id: showcase.id }

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses showcase query " do
      expect_any_instance_of(ShowcaseQuery).to receive(:find).with("1").and_return(showcase)
      subject
    end

    it "assigns a showcase decorator" do
      subject

      expect(assigns(:showcase)).to be_a_kind_of(ShowcaseDecorator)
    end

    it 'is a redirect' do
      subject

      expect(response).to be_redirect
    end

    it 'renders json' do
      get :show, id: showcase.id, format: :json

      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    subject { get :edit, id: showcase.id }

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses showcase query " do
      expect_any_instance_of(ShowcaseQuery).to receive(:find).with("1").and_return(showcase)
      subject
    end

    it "assigns a showcase" do
      subject

      assigns(:showcase)
      expect(assigns(:showcase)).to eq(showcase)
    end
  end

  describe "GET #title" do
    subject { get :title, id: showcase.id }

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses showcase query " do
      expect_any_instance_of(ShowcaseQuery).to receive(:find).with("1").and_return(showcase)
      subject
    end

    it "assigns a showcase" do
      subject

      assigns(:showcase)
      expect(assigns(:showcase)).to eq(showcase)
    end
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, id: showcase.id }

    it "calls destroy on the item on success, redirects, and flashes " do
      expect(showcase).to receive(:destroy!).and_return(true)

      subject
      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "assigns and item" do
      subject

      assigns(:showcase)
      expect(assigns(:showcase)).to eq(showcase)
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses showcase query " do
      expect_any_instance_of(ShowcaseQuery).to receive(:find).with("1").and_return(showcase)
      subject
    end
  end

end
