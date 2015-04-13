require 'rails_helper'

describe ReorderSections do
  subject { described_class.call(current_items_in_order, new_item) }

  let(:old_item_1) { instance_double(Section, order: 0, 'order=' => true, save!: true) }
  let(:old_item_2) { instance_double(Section, order: 1, 'order=' => true, save!: true) }
  let(:old_item_3) { instance_double(Section, order: 2, 'order=' => true, save!: true) }

  let(:current_items_in_order) { [old_item_1, old_item_2, old_item_3] }

  context 'insert at the front of the line' do
    let(:new_item) { instance_double(Section, order: 0) }

    it 'changes position of the first item' do
      expect(old_item_1).to receive('order=').with(1)
      expect(old_item_1).to receive(:save!)

      subject
    end

    it 'changes position of the last item' do
      expect(old_item_2).to receive('order=').with(2)
      expect(old_item_2).to receive(:save!)

      subject
    end
  end

  context 'insert in the middle of the line' do
    let(:new_item) { instance_double(Section, order: 1) }

    it 'changes position of the first item' do
      expect(old_item_1).to_not receive(:save!)

      subject
    end

    it 'changes position of the last item' do
      expect(old_item_2).to receive('order=').with(2)
      expect(old_item_2).to receive(:save!)

      subject
    end
  end

  context 'inserts at the end of the line' do
    let(:new_item) { instance_double(Section, order: 2) }

    it 'changes position of the first item' do
      expect(old_item_1).to_not receive(:save!)

      subject
    end

    it 'changes position of the last item' do
      expect(old_item_2).to_not receive(:save!)

      subject
    end
  end

  context 'fixes orders not in numeric order' do
    let(:new_item) { instance_double(Section, order: 5) }

    it 'changes position last item it it is not in order' do
      expect(new_item).to receive('order=').with(3)
      expect(new_item).to receive(:save!)

      subject
    end
  end

  context 'updates an item' do
    it 'moves an item earlier in the list' do
      allow(old_item_2).to receive(:order).and_return(0)
      expect(old_item_1).to receive('order=').with(1)
      described_class.call(current_items_in_order, old_item_2)
    end

    it 'moves an item later in the list' do
      allow(old_item_1).to receive(:order).and_return(2)
      expect(old_item_2).to receive('order=').with(0)
      expect(old_item_1).to receive('order=').with(1)
      described_class.call(current_items_in_order, old_item_1)
    end
  end
end
