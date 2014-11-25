require 'rails'

describe ItemQuery do
  describe '#initialize' do
    it 'extends the relation with the scopes' do
      relation = Item.all
      expect(relation).to receive(:extending).with(described_class::Scopes)
      query = described_class.new(relation)
    end
  end

  describe '#search' do
    it "returns the relation" do
      relation = Item.all
      query = described_class.new(relation)
      expect(query.search).to eq(relation)
    end
  end

  describe '#recent' do
    it 'calls the recent scope' do
      expect(subject.search).to receive(:recent).and_return('recent')
      expect(subject.recent()).to eq('recent')
    end
  end

  describe 'Scopes' do
    subject { described_class.new.search }

    describe '#recent' do
      it 'does not require an argument' do
        expect(subject.recent()).to be_a_kind_of(ActiveRecord::Relation)
      end

      it 'is ordered by update_at' do
        expect(subject).to receive(:order).with(updated_at: :desc).and_call_original
        subject.recent
      end

      it 'accepts limit as an option' do
        expect(subject).to receive(:limit).with(7).and_call_original
        subject.recent(7)
      end
    end

    describe '#exclude_children' do
      it 'searches for items with no parent_id' do
        expect(subject).to receive(:where).with(parent_id: nil).and_call_original
        subject.exclude_children
      end
    end
  end
end
