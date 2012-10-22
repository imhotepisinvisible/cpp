FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    password Faker::Lorem.words(2).join
    password_confirmation { password }
  end
end
