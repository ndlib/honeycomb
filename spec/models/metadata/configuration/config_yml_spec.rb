require "rails_helper"

RSpec.describe CreateCollectionConfiguration do
  Dir.glob(Rails.root.join("config/metadata/*.yml")).each do |path|
    describe path do
      let(:data) { YAML.load_file(path) }

      subject { described_class.new("").send(:base_config) }

      it "is valid" do
        expect(subject[:fields]).to be_kind_of(Array)
        expect(subject[:fields].first).to be_kind_of(Hash)
      end

      it "doesn't contain duplicate fields" do
        fields = data.fetch(:fields).map { |hash| hash[:name] }
        expect(fields).to eq(fields.uniq)
      end
    end
  end
end
