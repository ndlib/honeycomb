require "rails_helper"

describe Destroy::Page do
  let(:page) { instance_double(Page, id: 1) }

  before (:each) do
    allow_any_instance_of(SiteObjectsQuery).to receive(:exists?).and_return(false)
  end

  describe "#destroy" do
    it "destroys the Page" do
      expect(page).to receive(:destroy!)
      subject.destroy!(page: page)
    end

    it "does not destroy the Page if CanDelete fails" do
      expect(CanDelete).to receive(:page?).and_return(false)
      expect(page).not_to receive(:destroy!)
      subject.destroy!(page: page)
    end
  end

  describe "#cascade" do
    it "destroys the Page" do
      expect(page).to receive(:destroy!)
      expect(DestroyPageItemAssociations).to receive(:call).and_return(1)
      subject.cascade!(page: page)
    end

    it "doesn't destroy the Page if CanDelete fails" do
      expect(CanDelete).to receive(:page?).and_return(false)
      expect(page).not_to receive(:destroy!)
      expect(DestroyPageItemAssociations).not_to receive(:call)
      subject.cascade!(page: page)
    end

    it "returns nil if CanDelete fails" do
      expect(CanDelete).to receive(:page?).and_return(false)
      expect(subject.cascade!(page: page)).to be(nil)
    end

    it "can force destroy the Page" do
      expect(page).to receive(:destroy!)
      expect(DestroyPageItemAssociations).to receive(:call).and_return(1)
      subject.force_cascade!(page: page)
    end
  end

  context "cascade transaction" do
    let(:collection) { FactoryGirl.create(:collection) }
    let(:page) { FactoryGirl.create(:page) }

    # Ensures all data that was created still exists
    # in the database
    def data_still_exists!
      expect { page.reload }.not_to raise_error
    end

    it "rolls back if an error occurs with Page.destroy!" do
      collection
      page
      allow(page).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(page: page) }.to raise_error("error")
      data_still_exists!
    end
  end
end
