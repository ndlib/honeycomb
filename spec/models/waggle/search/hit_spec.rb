RSpec.describe Waggle::Search::Hit do
  let(:adapter_hit) do
    double(
      name: "name",
      at_id: "at_id",
      type: "Item",
      description: "Description",
      short_description: "short_description",
      date_created: "date_created",
      creator: "creator",
      thumbnail_url: "thumbnail",
      last_updated: "last_updated"
    )
  end
  subject { described_class.new(adapter_hit) }

  [
    :name,
    :at_id,
    :type,
    :description,
    :short_description,
    :date_created,
    :creator,
    :thumbnail_url,
    :last_updated,
  ].each do |field|
    describe "##{field}" do
      it "calls the appropriate method on the adapter_hit" do
        expect(adapter_hit).to receive(field)
        subject.send(field)
      end

      it "returns the data from the adapter_hit" do
        expect(subject.send(field)).to eq(adapter_hit.send(field))
      end
    end
  end
end
