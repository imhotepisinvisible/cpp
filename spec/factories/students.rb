# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student do
    email Faker::Internet.email
    password_digest Faker::Lorem.words(2).join
  end
end
