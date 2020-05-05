require "rails_helper"

RSpec.describe ReindexCollectionJob, type: :job do
  let(:collection_id) { 1 }
  let(:collection) { instance_double(Collection, id: 1, name_line_1: "name_line_1") }

  subject { described_class }

  describe "#perform" do
    before do
      allow(Collection).to receive(:find).and_return(collection)
    end

    it "calls Index::Collection.index! with params" do
      expect(Index::Collection).to receive(:index!).with(collection: collection)
      subject.perform_now(collection_id: collection_id)
    end
  end
end
