require "rails_helper"

# commented out because it is not in use.  Not removed because I think I want to bring it
# back in the next refactor
=begin
describe DateValidator do
  let(:item) { Item.new }

  it "passes the errors from metadata date to determine validity" do
    expect_any_instance_of(MetadataDate).to receive(:valid?).twice.and_return(true)
    i = Item.new(date_created: { year: "2010" })
    i.save
  end

  it "passes errors from metadata date to item errors" do
    allow_any_instance_of(MetadataDate).to receive(:valid?).and_return(false)
    expect_any_instance_of(MetadataDate).to receive(:errors).and_return(double(full_messages: ["error message"]))

    i = Item.new(date_created: { year: "2010" })
    i.save
  end

  it "does no validation if the field is empty" do
    expect_any_instance_of(MetadataDate).to_not receive(:valid?)
    Item.new.save
  end
end
=end
