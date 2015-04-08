require 'rails_helper'

RSpec.describe Section do

  [:title, :description, :image, :item_id, :order, :caption, :showcase, :item, :updated_at, :created_at].each do |field|
    it "has the field #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  [:showcase].each do | field |
    it "requires the field, #{field}" do
      expect(subject).to have(1).error_on(field)
    end
  end


end
