require "rails_helper"

RSpec.describe User do
  @f = [:first_name, :last_name, :display_name, :email]
  @f.each do | field |
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  @f.each do | field |
    it "requires field, #{field}" do
      expect(subject).to have(1).error_on(field)
    end
  end
end
