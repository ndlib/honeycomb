require "rails_helper"

RSpec.describe CacheKeys::Custom::V1Sections do
  context "show" do
    let(:collection) { instance_double(Collection, collection_configuration: "collection_configuration") }
    let(:decorated_section) do
      method_stubs = { object: "object",
                       item: "item",
                       item_children: "item_children",
                       next: "next",
                       previous: "previous",
                       collection: collection,
                       showcase: "showcase" }
      instance_double(V1::SectionJSONDecorator, method_stubs)
    end

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.show(decorated_section: decorated_section)
    end

    it "uses the correct data" do
      params = ["object", "item", "item_children", "next", "previous", collection, "collection_configuration", "showcase"]
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: params)
      subject.show(decorated_section: decorated_section)
    end
  end
end
