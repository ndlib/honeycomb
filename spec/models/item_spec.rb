require "rails_helper"

RSpec.describe Item do
  let(:item_metadata) do
    double(
      Metadata::Fields,
      valid?: true,
      field: [double(value: "value")],
      name: "name", user_defined_id: "user_defined_id", description: "descriptiom"
    )
  end

  before(:each) do
    allow(subject).to receive(:item_metadata).and_return(item_metadata)
  end

  [:name, :description].each do |field|
    it "delegates to item_metadata" do
      expect(subject.item_metadata).to receive(field).and_return(field)
      subject.send(field)
    end
  end

  [
    :collection,
    :media,
    :published,
    :pages
  ].each do |field|
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  it "requires the collection field" do
    expect(subject).to have(1).error_on(:collection)
  end

  it "requires the unique_id field" do
    expect(subject).to have(1).error_on(:unique_id)
  end

  it "requires the user_defined_id field" do
    expect(subject).to have(1).error_on(:user_defined_id)
  end

  describe "#manuscript_url" do
    it "is not required" do
      expect(subject).to have(0).errors_on(:manuscript_url)
    end

    it "is valid with a url" do
      subject.manuscript_url = "http://example.com/manuscript"
      expect(subject).to have(0).errors_on(:manuscript_url)
    end

    it "is invalid with a non url value" do
      subject.manuscript_url = "manuscript"
      expect(subject).to have(1).error_on(:manuscript_url)
    end
  end

  it "has a papertrail" do
    expect(subject).to respond_to(:paper_trail_enabled_for_model?)
    expect(subject.paper_trail_enabled_for_model?).to be(true)
  end

  it "has a parent" do
    expect(subject).to respond_to(:parent)
    expect(subject.parent).to be_nil
  end

  it "doesn't allow a relation depth greater than 1" do
    FactoryGirl.create(:collection)
    FactoryGirl.create(:item, user_defined_id: "one", unique_id: 1, id: 1)
    FactoryGirl.create(:item, id: 2, unique_id: 2, user_defined_id: 'two', parent_id: 1)
    expect { FactoryGirl.create(:item, id: 3, unique_id: 3, user_defined_id: 'three', parent_id: 2) }.to raise_error
  end

  it "has children" do
    expect(subject).to respond_to(:children)
    expect(subject.children).to eq([])
  end

  it "has sections" do
    expect(subject).to respond_to(:sections)
    expect(subject.sections).to eq([])
  end

  it "has showcases" do
    expect(subject).to respond_to(:showcases)
    expect(subject.showcases).to eq([])
  end

  describe "#has image interface" do
    it "responds to image" do
      expect(subject).to respond_to(:media)
    end

    it "responds to collection" do
      expect(subject).to respond_to(:collection)
    end
  end

  context "foreign key constraints" do
    before(:each) do
      allow_any_instance_of(Metadata::Fields).to receive(:valid?).and_return(true)
    end

    describe "#destroy" do
      it "fails if a section references it" do
        FactoryGirl.create(:collection)
        FactoryGirl.create(:showcase)
        subject = FactoryGirl.create(:item)
        FactoryGirl.create(:section, id: 1, item_id: 1)
        expect { subject.destroy }.to raise_error
      end

      it "fails if a child item references it" do
        FactoryGirl.create(:collection)
        FactoryGirl.create(:showcase)
        subject = FactoryGirl.create(:item, user_defined_id: "two")
        FactoryGirl.create(:item, id: 2, parent_id: 1)
        expect { subject.destroy }.to raise_error
      end
    end
  end

  describe "item_metadata" do
    it "returns the retreval object" do
      expect(subject).to receive(:item_metadata).and_return(item_metadata)
      expect(subject.item_metadata).to eq(item_metadata)
    end
  end

  describe "metadata=" do
    it "prevents you from calling this method" do
      expect { subject.metadata = ({}) }.to raise_error
    end
  end
end
