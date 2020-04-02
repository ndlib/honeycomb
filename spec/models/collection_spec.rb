require "rails_helper"

RSpec.describe Collection do
  [:name_line_1, :name_line_2, :items, :unique_id, :showcases,
   :collection_users, :published, :preview_mode, :users, :updated_at, :created_at,
   :short_intro, :showcases, :hide_title_on_home_page, :about, :copyright,
   :enable_search, :enable_browse, :image, :url_slug, :pages, :collection_configuration].each do |field|
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  it "requires the name_line_1 field " do
    expect(subject).to have(1).error_on(:name_line_1)
  end

  it "has a papertrail" do
    expect(subject).to respond_to(:paper_trail_enabled_for_model?)
    expect(subject.paper_trail_enabled_for_model?).to be(true)
  end

  describe "#name" do
    it "concatinates name_line_1 and name_line_2 if there is a name_line_2" do
      expect(subject).to receive(:name_line_1).and_return("name line 1")
      expect(subject).to receive(:name_line_2).twice.and_return("name line 2")

      expect(subject.name).to eq("name line 1 name line 2")
    end

    it "does not concatintate name_line_2 if there is no name_line_2" do
      expect(subject).to receive(:name_line_1).and_return("name line 1")
      expect(subject).to receive(:name_line_2).and_return(nil)

      expect(subject.name).to eq("name line 1")
    end
  end

  describe "#has honeypot image interface" do
    it "responds to image" do
      expect(subject).to respond_to(:image)
    end

    it "responds to image" do
      expect(subject).to respond_to(:image)
    end
  end

  describe "#url_slug" do
    it "enforces uniqueness through validation" do
      FactoryGirl.create(:collection, url_slug: "test")
      expect { FactoryGirl.create(:collection, url_slug: "test") }.to raise_error
    end
  end

  context "foreign key constraints" do
    before(:each) do
      allow_any_instance_of(Metadata::Fields).to receive(:valid?).and_return(true)
      allow_any_instance_of(Metadata::Fields).to receive(:set_metadata).and_return(true)
    end

    describe "#destroy" do
      it "fails if a CollectionUser references it" do
        FactoryGirl.create(:default_user)
        subject = FactoryGirl.create(:collection)
        FactoryGirl.create(:collection_user)
        expect { subject.destroy }.to raise_error
      end

      context "foreign key constraints" do
        describe "#destroy" do
          it "fails if a Showcase references it" do
            subject = FactoryGirl.create(:collection)
            FactoryGirl.create(:showcase)
            expect { subject.destroy }.to raise_error
          end
        end
      end

      it "fails if an Item references it" do
        subject = FactoryGirl.create(:collection)
        FactoryGirl.create(:item)
        expect { subject.destroy }.to raise_error
      end

      it "fails if a Page references it" do
        subject = FactoryGirl.create(:collection)
        FactoryGirl.create(:page)
        expect { subject.destroy }.to raise_error
      end
    end
  end
end
