FactoryGirl.define do
  factory :item do |i|
    i.id { 1 }
    i.collection_id { 1 }
    i.user_defined_id { "one" }
    i.unique_id { "one" }
  end
end
