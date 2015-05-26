FactoryGirl.define do
  factory :showcase do
    id { 1 }
    exhibit_id { 1 }
    name_line_1 { "Showcase One" }
    image_file_name "one.jpg"
    image_content_type "image/jpeg"
    image_file_size 1.megabyte

    factory :showcase_with_exhibit do
      after(:build, :create) do |s|
        s.exhibit = build(:exhibit_with_collection)
      end
    end
  end
end
