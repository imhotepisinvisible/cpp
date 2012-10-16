# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :placement do
    company_id 1
    position "MyString"
    description "MyText"
    duration "MyString"
    location "MyString"
    deadline "2012-10-16 21:00:49"
  end
end
