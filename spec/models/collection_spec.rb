require "rails_helper"

RSpec.describe Collection do
  [:title, :items, :description, :unique_id, :showcases, :exhibit, :collection_users, :users, :updated_at, :created_at].each do | field |

    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  it "requires the title field " do
    expect(subject).to have(1).error_on(:title)
  end

  it "has paper trail" do
    expect(subject).to respond_to(:versions)
  end

  describe '#beehive_url' do
    it 'is a url to the beehive server' do
      expect(subject.beehive_url).to include(Rails.configuration.settings.beehive_url)
    end
  end


end
