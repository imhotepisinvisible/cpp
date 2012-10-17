# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    company_id 1
    title "MyString"
    date "2012-10-16 20:57:37"
    deadline "2012-10-16 20:57:37"
    description "MyText"
    location "MyString"
    capacity 1
    google_map_url "MyString"
  end
end
