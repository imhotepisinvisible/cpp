# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email "MyString"
    first_name "MyString"
    last_name "MyString"
    year 1
    subject "MyString"
    bio "MyText"
    password_digest "MyString"
  end
end
