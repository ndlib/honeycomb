require "rails_helper"

RSpec.describe TiledImage do
  [:width, :height, :host, :path, :item].each do | field |
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  [:width, :height, :host, :path].each do | field |
    it "validates the #{field}" do
      expect(subject).to have(1).error_on(field)
    end
  end

end
