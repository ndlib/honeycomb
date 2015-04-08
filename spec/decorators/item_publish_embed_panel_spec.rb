require 'rails_helper'

RSpec.describe ItemPublishEmbedPanel do
  subject { described_class.new(item) }
  let(:item) { double(Item, published: true, id: 1 )}

  describe "display" do
    it "renders a react component" do
      expect(subject.h).to receive(:react_component).with("ItemPublishEmbedPanel", {:item=>item, :embedBaseUrl=> Rails.configuration.settings.beehive_url, :publishPanelTitle=>"Publish", :publishPanelHelp=>"Choose if this item can be viewed.", :publishPanelFieldName=>"Published", :embedPanelTitle=>"Embed", :embedPanelHelp=>"Copy and paste this code into the website where you want to embed this item.", :published=>true, :publishPath=>"/items/1/publish", :unpublishPath=>"/items/1/unpublish"})
      subject.display
    end
  end

  describe "class#display" do
    it "calls the display method" do
      expect_any_instance_of(described_class).to receive(:display)
      described_class.display(item)
    end
  end
end

