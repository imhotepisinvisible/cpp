FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    password Faker::Lorem.characters(8)
    password_confirmation { password }
    first_name "Sarah"
    last_name "Tattersall"
  end
end
